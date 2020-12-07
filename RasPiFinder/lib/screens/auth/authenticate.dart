import 'package:RasPiFinder/screens/auth/signup/signup_page.dart';
import 'package:flutter/material.dart';

import 'login/login_page.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginPage(toggle: toggleView);
    } else {
      return SignupPage(toggle: toggleView);
    }
  }
}