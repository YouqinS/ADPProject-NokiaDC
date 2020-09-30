import 'package:RasPiFinder/auth/components/app_bar.dart';
import 'package:RasPiFinder/auth/components/navigate.dart';
import 'package:RasPiFinder/auth/components/password_input_field.dart';
import 'package:RasPiFinder/auth/components/rounded_button.dart';
import 'package:RasPiFinder/auth/components/signup_signin_check.dart';
import 'package:RasPiFinder/auth/components/text_input_field.dart';
import 'package:RasPiFinder/auth/login/login_page.dart';
import 'package:RasPiFinder/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key key}) : super(key: key);

  @override
  SignupForm createState() => new SignupForm();
}

class SignupForm extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: piAppBar,
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
               navigateToPage(context, HomePage());
              },
            ),
            SizedBox(height: size.height * 0.03),
            SignupSigninCheck(
              login: false,
              press: () {
                navigateToPage(context, LoginPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
