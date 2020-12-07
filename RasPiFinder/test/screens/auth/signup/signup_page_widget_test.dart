import 'package:RasPiFinder/screens/auth/signup/signup_page.dart';
import 'package:RasPiFinder/screens/components/password_input_field.dart';
import 'package:RasPiFinder/screens/components/rounded_button.dart';
import 'package:RasPiFinder/screens/components/text_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  Widget buildTestableWidget(Widget widget) {
    return new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: widget)
    );
  }

  group('Find and test widgets', () {
    testWidgets('Find widgets', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(SignupPage()));

      final scaffoldFinder = find.byType(Scaffold);
      final columnFinder = find.byType(Column);
      final rowFinder = find.byType(Row);
      final formFinder = find.byType(Form);
      final textinputfieldFinder = find.byType(TextInputField);
      final passwdfieldFinder = find.byType(PasswordInputField);
      final buttonFinder = find.byType(RoundedButton);

      await tester.pump();

      expect(scaffoldFinder, findsOneWidget);
      expect(columnFinder, findsNWidgets(3));
      expect(rowFinder, findsNWidgets(2));
      expect(formFinder, findsOneWidget);
      expect(textinputfieldFinder, findsNWidgets(3));
      expect(passwdfieldFinder, findsOneWidget);
      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('Test text fields and button', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(SignupPage()));

      await tester.enterText(find.byType(TextInputField).first, 'John');
      await tester.enterText(find.byType(TextInputField).at(2), 'aa@aa.fi');
      await tester.enterText(find.byType(TextInputField).last, '1234567890');
      await tester.enterText(find.byType(PasswordInputField), '12345678');

      await tester.tap(find.byType(RoundedButton));

      await tester.pumpAndSettle();
      
    });
  });
}
