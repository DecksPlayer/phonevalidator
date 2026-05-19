import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cellphone_validator/cellphone_validator.dart';

void main() {
  testWidgets('PhoneCountryInput widget test with countryIsoCode', (WidgetTester tester) async {
    final phoneValidator = PhoneValidator(lang: 'en');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PhoneCountryInput(
            phoneValidator: phoneValidator,
            countryIsoCode: 'AF', // Afghanistan: dialCode '93', mask '### ### ####'
          ),
        ),
      ),
    );

    // Verify it resolved country to Afghanistan
    expect(find.byType(PhoneCountryInput), findsOneWidget);
    
    // Check that visual text prefix (+93) is present
    expect(find.text('+93'), findsOneWidget);

    // Enter a number without prefix
    await tester.enterText(find.byType(TextField), '2055555555');
    await tester.pumpAndSettle();

    // Verify it formats with the mask: "205 555 5555"
    final TextField textField = tester.widget(find.byType(TextField));
    expect(textField.controller!.text, '205 555 5555');

    // Verify phone validation works (Afghanistan requires 9 digits after dial code, let's check pattern: r'^\+93\d{9}$')
    // Wait, 2055555555 is 10 digits. Let's enter 9 digits: '205555555'
    await tester.enterText(find.byType(TextField), '205555555');
    await tester.pumpAndSettle();
    expect(textField.controller!.text, '205 555 555');
    expect(phoneValidator.isValidPhoneNotifier.value, true);
    expect(phoneValidator.phone, '+93205555555');
  });

  testWidgets('PhoneCountryInput handles prefixed number entered or pasted', (WidgetTester tester) async {
    final phoneValidator = PhoneValidator(lang: 'en');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PhoneCountryInput(
            phoneValidator: phoneValidator,
            countryIsoCode: 'AF',
          ),
        ),
      ),
    );

    // Enter a number starting with +93 (or 93) with exactly 9 local digits
    await tester.enterText(find.byType(TextField), '+93205555555');
    await tester.pumpAndSettle();

    final TextField textField = tester.widget(find.byType(TextField));
    // The textfield should clean the prefix and format: "205 555 555"
    expect(textField.controller!.text, '205 555 555');
    
    // Check validation
    expect(phoneValidator.isValidPhoneNotifier.value, true);
  });
}
