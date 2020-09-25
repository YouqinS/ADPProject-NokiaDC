import 'package:RasPiFinder/auth/components/signup_signin_check.dart';
import 'package:RasPiFinder/auth/components/rounded_button.dart';
import 'package:RasPiFinder/auth/components/text_input_field.dart';
import 'package:RasPiFinder/auth/components/password_input_field.dart';
import 'package:RasPiFinder/auth/signup/signup_page.dart';
import 'package:RasPiFinder/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "RasPiFinder",
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextInputField(
              hintText: "Username",
              icon: Icons.person,
              onChanged: (value) {},
            ),
            PasswordInputField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "Sign In",
              //TODO connect to DB to store user credentials and status
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HomePage();
                    },
                  ),
                );
              },
            ),
            SizedBox(height: size.height * 0.03),
            SignupSigninCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignupPage();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
