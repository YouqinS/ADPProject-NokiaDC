import 'package:RasPiFinder/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:test/test.dart';
import 'package:RasPiFinder/services/authentication_service.dart';

void main() async {
  test('Authentication service shoud login with email & password', () async {
    final authService = AuthenticationService();
    MUser user =
        await authService.signInWithEmailAndPassword('foo@bar', '123456');

    expect(user.uid, isNotEmpty);
  });
}
