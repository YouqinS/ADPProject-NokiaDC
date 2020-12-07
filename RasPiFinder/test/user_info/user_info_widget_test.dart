import 'package:RasPiFinder/main.dart';
import 'package:RasPiFinder/user_info/user_info.dart';
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

  Widget makeTestableWidget(Widget child) {
    return RasPiFinder(); }

  testWidgets('User info widget test', (WidgetTester tester) async{

    await tester.pumpWidget(makeTestableWidget(UserInfo()));

    await tester.idle();
    await tester.pump();

    final columnFinder = find.byType(Column);
    final rowFinder = find.byType(Row);
    final sizedBoxFinder = find.byType(SizedBox);
    final textFinder = find.byType(Text);
    final iconFinder = find.byType(Icon);
    final buttonFinder = find.byType(FloatingActionButton);

    expect(columnFinder, findsNWidgets(2));
    expect(rowFinder, findsNWidgets(2));
    expect(sizedBoxFinder, findsNWidgets(1));
    expect(textFinder, findsNWidgets(3));
    expect(iconFinder, findsNWidgets(1));
    expect(buttonFinder, findsNothing);

    expect(find.text('a'), findsNothing);
  });
}
