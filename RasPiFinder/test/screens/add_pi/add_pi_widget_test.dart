import 'package:RasPiFinder/screens/add_pi/add_pi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../mock.dart';


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
      await tester.pumpWidget(buildTestableWidget(AddPi()));

      final scaffoldFinder = find.byType(Scaffold);
      final columnFinder = find.byType(Column);
      final rowFinder = find.byType(Row);
      final textFormFieldFinder = find.byType(TextFormField);
      final buttonFinder = find.byType(RaisedButton);

      await tester.pump();

      expect(scaffoldFinder, findsOneWidget);
      expect(columnFinder, findsNWidgets(2));
      expect(rowFinder, findsNWidgets(3));
      expect(textFormFieldFinder, findsNWidgets(3));
      expect(buttonFinder, findsNWidgets(2));
    });

    testWidgets('Test widget and buttons', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(AddPi()));

      await tester.enterText(find.byType(TextFormField).first, 'Finland');
      await tester.enterText(find.byType(TextFormField).at(2), 'Pi 2020');
      await tester.enterText(find.byType(TextFormField).last, 'Abc123');

      await tester.tap(find.byType(RaisedButton).first);
      await tester.tap(find.byType(RaisedButton).last);

      await tester.pump();

      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });
}