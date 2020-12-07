import 'package:RasPiFinder/screens/profile/my_pi.dart';
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
      await tester.pumpWidget(makeTestableWidget(MyRasPi()));

      final stackFinder = find.byType(Stack);
      final containerFinder = find.byType(Container);
      final scaffoldFinder = find.byType(Scaffold);

      await tester.pump();

      expect(stackFinder, findsNWidgets(2));
      expect(containerFinder, findsWidgets);
      expect(scaffoldFinder, findsOneWidget);
    });
  }



