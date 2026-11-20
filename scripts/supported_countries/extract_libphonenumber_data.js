// Extracts, for every country, the official fixed-line and mobile national
// number patterns from Google's libphonenumber metadata (via libphonenumber-js)
// and derives the list of area codes / mobile prefixes from them.
//
// Usage (from the repo root):
//   npm install --no-save libphonenumber-js      (or have it on NODE_PATH)
//   node scripts/supported_countries/extract_libphonenumber_data.js
//   dart run scripts/supported_countries/generate_supported_countries.dart
//
// Output: scripts/supported_countries/libphonenumber_data.json
//   { "<ISO>": { fixedLinePattern, mobilePattern, areaCodes: [string] } }
//
// "Area codes" are the shortest prefixes after which the rest of the number
// can be any digits allowed by the pattern, regardless of which ones. They're
// computed exactly from the regex (converted to an automaton), so they cover
// both landline area codes and mobile prefixes, and keep leading zeros.
// For dial codes shared by several countries (+1, +7, +44...), they are the
// shortest prefixes that tell the country apart (e.g. "264" for Anguilla).

const fs = require('fs');
const path = require('path');

const metadata = require('libphonenumber-js/metadata.max.json');
const { parsePhoneNumber } = require('libphonenumber-js/max');
const libVersion = require('libphonenumber-js/package.json').version;

// ---------------------------------------------------------------------------
// Minimal regex parser for libphonenumber patterns:
// digits, \d, [..] classes with ranges, (?:..) groups, |, ?, {n}, {n,m}.
// ---------------------------------------------------------------------------
function parse(src) {
  let i = 0;
  const ALL = 0x3ff; // bitmask of digits 0-9

  function parseAlt() {
    const branches = [parseSeq()];
    while (src[i] === '|') {
      i++;
      branches.push(parseSeq());
    }
    return { type: 'alt', branches };
  }

  function parseSeq() {
    const items = [];
    while (i < src.length && src[i] !== '|' && src[i] !== ')') {
      let atom = parseAtom();
      // quantifiers
      while (i < src.length && (src[i] === '?' || src[i] === '{')) {
        if (src[i] === '?') {
          i++;
          atom = { type: 'rep', node: atom, min: 0, max: 1 };
        } else {
          const m = /^\{(\d+)(?:,(\d*))?\}/.exec(src.slice(i));
          if (!m) throw new Error(`Bad quantifier at ${i} in ${src}`);
          i += m[0].length;
          const min = Number(m[1]);
          const max = m[2] === undefined ? min : m[2] === '' ? Infinity : Number(m[2]);
          if (max === Infinity) throw new Error(`Unbounded quantifier in ${src}`);
          atom = { type: 'rep', node: atom, min, max };
        }
      }
      items.push(atom);
    }
    return { type: 'seq', items };
  }

  function parseAtom() {
    const c = src[i];
    if (c === '(') {
      i++;
      if (src.startsWith('?:', i)) i += 2;
      const node = parseAlt();
      if (src[i] !== ')') throw new Error(`Missing ) at ${i} in ${src}`);
      i++;
      return node;
    }
    if (c === '[') {
      i++;
      let mask = 0;
      while (src[i] !== ']') {
        let a;
        if (src[i] === '\\' && src[i + 1] === 'd') {
          mask |= ALL;
          i += 2;
          continue;
        }
        a = Number(src[i++]);
        if (src[i] === '-' && src[i + 1] !== ']') {
          const b = Number(src[i + 1]);
          i += 2;
          for (let d = a; d <= b; d++) mask |= 1 << d;
        } else {
          mask |= 1 << a;
        }
      }
      i++;
      return { type: 'set', mask };
    }
    if (c === '\\' && src[i + 1] === 'd') {
      i += 2;
      return { type: 'set', mask: ALL };
    }
    if (c >= '0' && c <= '9') {
      i++;
      return { type: 'set', mask: 1 << Number(c) };
    }
    throw new Error(`Unexpected "${c}" at ${i} in ${src}`);
  }

  const ast = parseAlt();
  if (i !== src.length) throw new Error(`Trailing input at ${i} in ${src}`);
  return ast;
}

// ---------------------------------------------------------------------------
// Thompson NFA
// ---------------------------------------------------------------------------
function buildNfa(ast) {
  const eps = []; // eps[state] = [states]
  const trans = []; // trans[state] = [[mask, target]]
  const newState = () => {
    eps.push([]);
    trans.push([]);
    return eps.length - 1;
  };

  // returns [start, end]
  function build(node) {
    switch (node.type) {
      case 'set': {
        const s = newState();
        const e = newState();
        trans[s].push([node.mask, e]);
        return [s, e];
      }
      case 'seq': {
        const s = newState();
        let cur = s;
        for (const item of node.items) {
          const [a, b] = build(item);
          eps[cur].push(a);
          cur = b;
        }
        return [s, cur];
      }
      case 'alt': {
        const s = newState();
        const e = newState();
        for (const br of node.branches) {
          const [a, b] = build(br);
          eps[s].push(a);
          eps[b].push(e);
        }
        return [s, e];
      }
      case 'rep': {
        const s = newState();
        let cur = s;
        const e = newState();
        for (let k = 0; k < node.max; k++) {
          if (k >= node.min) eps[cur].push(e);
          const [a, b] = build(node.node);
          eps[cur].push(a);
          cur = b;
        }
        eps[cur].push(e);
        return [s, e];
      }
    }
    throw new Error('unknown node');
  }

  const [start, accept] = build(ast);
  return { eps, trans, start, accept };
}

const sigIds = new Map();

function makeAutomaton(pattern) {
  const nfa = buildNfa(parse(pattern));
  const closureCache = new Map();

  function closure(states) {
    const seen = new Set();
    const stack = [...states];
    while (stack.length) {
      const s = stack.pop();
      if (seen.has(s)) continue;
      seen.add(s);
      for (const t of nfa.eps[s]) stack.push(t);
    }
    // keep only states that matter: those with digit transitions, or accept
    return [...seen]
      .filter((s) => nfa.trans[s].length || s === nfa.accept)
      .sort((a, b) => a - b);
  }

  const startSet = closure([nfa.start]);
  const sets = new Map(); // key -> {states, next: [], sig}
  function intern(states) {
    const key = states.join(',');
    let entry = sets.get(key);
    if (!entry) {
      entry = { key, states, next: null, sig: null };
      sets.set(key, entry);
    }
    return entry;
  }

  function step(entry, d) {
    if (!entry.next) {
      entry.next = [];
      for (let digit = 0; digit < 10; digit++) {
        const targets = [];
        for (const s of entry.states) {
          for (const [mask, t] of nfa.trans[s]) {
            if (mask & (1 << digit)) targets.push(t);
          }
        }
        entry.next.push(targets.length ? intern(closure(targets)) : null);
      }
    }
    return entry.next[d];
  }

  // Language signature: equal signatures <=> equal accepted suffix languages.
  // [sigIds] is shared by all automata, so signatures compare across countries.
  function signature(entry) {
    if (entry.sig !== null) return entry.sig;
    const accepting = entry.states.includes(nfa.accept) ? 1 : 0;
    const parts = [accepting];
    for (let d = 0; d < 10; d++) {
      const n = step(entry, d);
      parts.push(n ? signature(n) : -1);
    }
    const k = parts.join(',');
    let id = sigIds.get(k);
    if (id === undefined) {
      id = sigIds.size;
      sigIds.set(k, id);
    }
    entry.sig = id;
    return id;
  }

  // "Free": what follows doesn't depend on which allowed digits are typed.
  const freeCache = new Map();
  function isFree(entry) {
    if (freeCache.has(entry.key)) return freeCache.get(entry.key);
    let result = true;
    let childSig = null;
    let child = null;
    for (let d = 0; d < 10 && result; d++) {
      const n = step(entry, d);
      if (!n) continue;
      const sig = signature(n);
      if (childSig === null) {
        childSig = sig;
        child = n;
      } else if (sig !== childSig) {
        result = false;
      }
    }
    if (result && child) result = isFree(child);
    freeCache.set(entry.key, result);
    return result;
  }

  const accepts = (entry) => entry.states.includes(nfa.accept);

  // Any valid number starting with [prefix] (shortest, smallest digits).
  function complete(prefix) {
    let entry = intern(startSet);
    for (const ch of prefix) {
      entry = step(entry, Number(ch));
      if (!entry) return null;
    }
    let number = prefix;
    while (!accepts(entry)) {
      let d = 0;
      while (d < 10 && !step(entry, d)) d++;
      if (d === 10) return null;
      number += d;
      entry = step(entry, d);
    }
    return number;
  }

  return { start: intern(startSet), step, isFree, complete, signature };
}

// Longest prefix explored when a number range is shared with another country
// that has the same dial code (genuine overlaps would otherwise never end).
const MAX_SHARED_PREFIX = 8;

// [siblings] are the automata of other countries with the same dial code
// (e.g. US, CA, DO... for +1): a prefix is only an area code of this country
// once no sibling has numbers starting with it.
// [rank] orders countries sharing a dial code (0 = main country, e.g. AU for
// +61). A range genuinely shared with a higher-ranked sibling belongs to that
// sibling, as in libphonenumber.
function areaCodesFor(a, siblings, rank) {
  const codes = [];
  (function dfs(prefix, entry, sibEntries) {
    // A sibling accepting exactly the same numbers from here is a genuine
    // overlap (same numbers valid in both): going deeper can't separate them.
    const ownSig = a.signature(entry);
    const genuineOverlap =
      sibEntries.length > 0 &&
      sibEntries.every(([sib, e]) => sib.signature(e) === ownSig);
    if (genuineOverlap && sibEntries.some(([sib]) => sib.rank < rank)) return;
    const shared =
      sibEntries.length > 0 && !genuineOverlap && prefix.length < MAX_SHARED_PREFIX;
    // With a shared dial code, the area code is the shortest prefix that no
    // sibling uses (e.g. "264" for Anguilla within +1). Otherwise it's the
    // shortest prefix after which any allowed digits may follow.
    const identifies = siblings.length > 0 && !shared;
    if (prefix && !shared && (identifies || a.isFree(entry))) {
      // Include digits that are forced (only one possible), e.g. "1" -> "11".
      let code = prefix;
      let cur = entry;
      for (;;) {
        const live = [];
        for (let d = 0; d < 10; d++) if (a.step(cur, d)) live.push(d);
        if (live.length !== 1) break;
        code += live[0];
        cur = a.step(cur, live[0]);
      }
      codes.push(code);
      return;
    }
    if (prefix.length >= MAX_SHARED_PREFIX) {
      codes.push(prefix);
      return;
    }
    for (let d = 0; d < 10; d++) {
      const n = a.step(entry, d);
      if (!n) continue;
      const nextSibs = [];
      for (const [sib, e] of sibEntries) {
        const s = sib.step(e, d);
        if (s) nextSibs.push([sib, s]);
      }
      dfs(prefix + d, n, nextSibs);
    }
  })('', a.start, siblings.map((s) => [s, s.start]));
  return codes;
}

// ---------------------------------------------------------------------------
// Metadata layout (libphonenumber-js compressed): country[11] = types array,
// index 0 = fixed line, 1 = mobile; each [pattern, possibleLengths?].
// An empty mobile pattern means "same as fixed line".
// ---------------------------------------------------------------------------
const entries = {};
for (const [iso, country] of Object.entries(metadata.countries)) {
  const types = country[11] || [];
  const fixed = types[0] && types[0][0] ? types[0][0] : '';
  let mobile = types[1] && types[1][0] ? types[1][0] : '';
  if (!mobile && fixed && types[1]) mobile = fixed;
  const combined = [fixed, mobile].filter(Boolean).map((p) => `(?:${p})`).join('|');
  const rank = (metadata.country_calling_codes[country[0]] || [iso]).indexOf(iso);
  const automaton = combined ? makeAutomaton(combined) : null;
  if (automaton) automaton.rank = rank;
  entries[iso] = { dialCode: country[0], fixed, mobile, rank, automaton };
}

// The derived prefixes can go past the real area code when the subscriber
// number's first digit is also restricted (Paraná: "3434", "3435"... instead
// of "343"). libphonenumber's national format knows the area code length
// ("0343 412-3456"), so trim each prefix to it. A leading mobile token is
// kept (Argentine mobiles: "9" + "343").
function trimToFormattedAreaCode(iso, automaton, codes) {
  const nationalPrefix = metadata.countries[iso][5];
  const trimmed = codes.map((code) => {
    const number = automaton.complete(code);
    if (!number) return code;
    let group;
    try {
      group = parsePhoneNumber(number, iso).formatNational().match(/\d+/)[0];
    } catch (_) {
      return code;
    }
    if (nationalPrefix && group.startsWith(nationalPrefix) && !number.startsWith(group)) {
      group = group.slice(nationalPrefix.length);
    }
    let area = null;
    if (number.startsWith(group)) area = group;
    else if (number.slice(1).startsWith(group)) area = number[0] + group;
    return area && code.length > area.length && code.startsWith(area) ? area : code;
  });
  // Dedupe and drop codes covered by a shorter one.
  const sorted = [...new Set(trimmed)].sort((x, y) => x.length - y.length || (x < y ? -1 : 1));
  return sorted.filter((c, i) => !sorted.slice(0, i).some((p) => c.startsWith(p)));
}

const result = {};
for (const [iso, e] of Object.entries(entries)) {
  const siblings = Object.entries(entries)
    .filter(([other, o]) => other !== iso && o.dialCode === e.dialCode && o.automaton)
    .map(([, o]) => o.automaton);
  let areaCodes = e.automaton ? areaCodesFor(e.automaton, siblings, e.rank) : [];
  // Only where the dial code isn't shared: there, prefixes must keep telling
  // the countries apart.
  if (e.automaton && siblings.length === 0) {
    areaCodes = trimToFormattedAreaCode(iso, e.automaton, areaCodes);
  }
  areaCodes.sort((x, y) => x.length - y.length || (x < y ? -1 : 1));
  result[iso] = { fixedLinePattern: e.fixed, mobilePattern: e.mobile, areaCodes };
}

const outFile = path.join(__dirname, 'libphonenumber_data.json');
fs.writeFileSync(
  outFile,
  JSON.stringify({ source: `libphonenumber-js ${libVersion}`, countries: result }, null, 1)
);
console.log(`Wrote ${Object.keys(result).length} countries to ${outFile}`);
