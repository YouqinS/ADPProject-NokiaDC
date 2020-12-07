import 'package:RasPiFinder/app_user/app_user.dart';
import 'package:RasPiFinder/components/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import '../mock.dart';


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
      await tester.pumpWidget(buildTestableWidget(AppUser()));

      final scaffoldFinder = find.byType(Scaffold);
      final cardFinder = find.byType(Card);
      final formFinder = find.byType(Form);
      final columnFinder = find.byType(Column);
      final rowFinder = find.byType(Row);
      final textFormFieldFinder = find.byType(TextFormField);
      final roundedButtonFinder = find.byType(RoundedButton);
      final sizedBoxFinder = find.byType(SizedBox);
      final dropDownButtonFinder = find.text('Pi Finder');

      await tester.pump();

      expect(scaffoldFinder, findsOneWidget);
      expect(cardFinder, findsOneWidget);
      expect(formFinder, findsOneWidget);
      expect(columnFinder, findsNWidgets(2));
      expect(rowFinder, findsNWidgets(2));
      expect(textFormFieldFinder, findsNWidgets(3));
      expect(roundedButtonFinder, findsOneWidget);
      expect(sizedBoxFinder, findsNWidgets(11));
      expect(dropDownButtonFinder, findsOneWidget);
    });

    testWidgets('Test widget and buttons', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(AppUser()));

      await tester.enterText(find.byType(TextFormField).first, 'Finland');
      await tester.enterText(find.byType(TextFormField).at(2), 'Pi 2020');
      await tester.enterText(find.byType(TextFormField).last, 'Abc123');

      await tester.tap(find.byType(RoundedButton));

      await tester.pump();

      expect(find.text('Save'), findsOneWidget);
    });
  });
}