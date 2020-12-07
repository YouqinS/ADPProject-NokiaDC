import 'package:RasPiFinder/screens/auth/login/login_page.dart';
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
      await tester.pumpWidget(buildTestableWidget(LoginPage()));

      final scaffoldFinder = find.byType(Scaffold);
      final columnFinder = find.byType(Column);
      final textinputfieldFinder = find.byType(TextInputField);
      final passwdfieldFinder = find.byType(PasswordInputField);
      final buttonFinder = find.byType(RoundedButton);

      await tester.pump();

      expect(scaffoldFinder, findsOneWidget);
      expect(columnFinder, findsNWidgets(3));
      expect(textinputfieldFinder, findsOneWidget);
      expect(passwdfieldFinder, findsOneWidget);
      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('Test text fields and button', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(LoginPage()));

      await tester.enterText(find.byType(TextInputField), 'aa@aa.com');
      await tester.enterText(find.byType(PasswordInputField), '12345678');

      await tester.tap(find.byType(RoundedButton));

      await tester.pump();

      Finder hintText = find.text('Sign In');
      expect(hintText.toString().contains('Sign'), true);
    });
  });
}
