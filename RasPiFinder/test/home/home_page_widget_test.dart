import 'package:flutter/material.dart';
import 'package:RasPiFinder/home/home_page.dart';
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
      await tester.pumpWidget(makeTestableWidget(HomePage()));

      final scaffoldFinder = find.byType(Scaffold);

      await tester.pump();

      expect(scaffoldFinder, findsOneWidget);
    });

    testWidgets('Test button', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(HomePage()));

      await tester.pump();

      await tester.tap(find.byType(FlatButton).first);
    });
  });
}
