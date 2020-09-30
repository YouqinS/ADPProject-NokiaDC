import 'package:RasPiFinder/auth/components/password_input_field.dart';
import 'package:RasPiFinder/auth/components/rounded_button.dart';
import 'package:RasPiFinder/auth/components/signup_signin_check.dart';
import 'package:RasPiFinder/auth/components/text_input_field.dart';
import 'package:RasPiFinder/auth/login/login_page.dart';
import 'package:RasPiFinder/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
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
              fontSize: 20),
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
            TextInputField(
              hintText: "Email",
              icon: Icons.email,
              onChanged: (value) {},
            ),
            PasswordInputField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "Sign Up",
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
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginPage();
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
