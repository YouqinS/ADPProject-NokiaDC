import 'package:RasPiFinder/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:RasPiFinder/services/authentication_service.dart';
import 'package:flutter_test/flutter_test.dart';
import '../mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  test('Authentication service shoud login with email & password', () async {
    final authService = AuthenticationService();
    MUser user =
        await authService.signInWithEmailAndPassword('foo@bar', '123456');
    MUser currentUser = await authService.user.first;

    expect(user.uid, '123456');
    expect(currentUser.uid, '123456');
  });

  test('Authentication service shoud login anonymously', () async {
    final authService = AuthenticationService();
    MUser user = await authService.signInAnon();
    expect(user.uid, '123456');
  });

  // test('Authentication service shoud register with email & password', () async {
  //   final authService = AuthenticationService();
  //   MUser user = await authService.registerWithEmailAndPassword(
  //       'foo@bar', 'password', 'foo.bar', '0909123456');
  //   // expect(user.uid, '123456');
  // });
}
