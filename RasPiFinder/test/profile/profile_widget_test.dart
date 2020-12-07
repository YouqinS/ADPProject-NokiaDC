import 'package:RasPiFinder/home/profile.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import '../mock.dart';


void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  Widget makeTestableWidget(Widget child) {
    return RasPiFinder(); }

  group('Find and test widgets', () {
    testWidgets('Find widgets', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(Profile()));

      final stackFinder = find.byType(Stack);
      final containerFinder = find.byType(Container);
      final scaffoldFinder = find.byType(Scaffold);
      final flatbtnFinder = find.byType(FlatButton);
      final singleChildSclFinder = find.byType(SingleChildScrollView);
      final sizedBoxFinder = find.byType(SizedBox);


      await tester.pump();

      expect(stackFinder, findsNWidgets(2));
      expect(containerFinder, findsWidgets);
      expect(scaffoldFinder, findsOneWidget);
      expect(flatbtnFinder, findsNWidgets(2));
      expect(singleChildSclFinder, findsOneWidget);
      expect(sizedBoxFinder, findsWidgets);
    });

    testWidgets('Test button', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(Profile()));

      tester.tap(find.byType(FlatButton).first);

    });
  });
}
