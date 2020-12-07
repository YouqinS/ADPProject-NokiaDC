import 'package:RasPiFinder/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'mock.dart';


void main() {

  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });


  testWidgets('main.dart widget test', (WidgetTester tester) async {

    // Render the widget.
    await tester.pumpWidget(RasPiFinder());
    // Let the snapshots stream fire a snapshot.
    await tester.idle();
    // Re-render.
    await tester.pump();
    // // Verify the output.
    expect(find.text('a'), findsNothing);
  });
}