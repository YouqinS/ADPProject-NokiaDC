import 'package:flutter/material.dart';

class SignupSigninCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const SignupSigninCheck({
    Key key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "No account yet? " : "Already have an Account? ",
          style: TextStyle(color: Colors.blue),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }
}
