import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cellphone_validator/cellphone_validator.dart';

void main() {
  testWidgets('PhoneAutoDetectView initializes and formats phone number according to country mask', (WidgetTester tester) async {
    final phoneValidator = PhoneValidator(lang: 'es');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PhoneAutoDetectView(
            phoneValidator: phoneValidator,
            fullPhoneNumber: '+34612345678', // Spain, dial code 34, mask: "### ### ###"
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final TextField textField = tester.widget(find.byType(TextField));
    expect(textField.controller!.text, '612 34 56 78');
  });

  testWidgets('PhoneAutoDetectView auto-detects and formats on input', (WidgetTester tester) async {
    final phoneValidator = PhoneValidator(lang: 'es');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PhoneAutoDetectView(
            phoneValidator: phoneValidator,
            fullPhoneNumber: '',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '34612345678');
    await tester.pumpAndSettle();

    final TextField textField = tester.widget(find.byType(TextField));
    expect(textField.controller!.text, '612 34 56 78');
  });
}
