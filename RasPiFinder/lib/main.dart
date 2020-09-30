import 'package:RasPiFinder/auth/login/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(RasPiFinder());
}

class RasPiFinder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO add logic to load LoginPage if user not logged in, otherwise Homepage
    return MaterialApp(
      home: LoginPage(),
    );
  }
}
