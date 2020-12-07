import 'package:RasPiFinder/screens/pi_data/pi_data.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  Widget makeTestableWidget(Widget child) {
    return RasPiFinder(); }

    testWidgets('Find widgets', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(PiData()));

      final scaffoldFinder = find.byType(Scaffold);
      final singleChildSclFinder = find.byType(SingleChildScrollView);
      final sizedBoxFinder = find.byType(SizedBox);
      final columnFinder = find.byType(Column);
      final containerFinder = find.byType(Container);


      await tester.pump();

      expect(scaffoldFinder, findsOneWidget);
      expect(singleChildSclFinder, findsOneWidget);
      expect(sizedBoxFinder, findsWidgets);
      expect(columnFinder, findsWidgets);
      expect(containerFinder, findsWidgets);
    });
}
