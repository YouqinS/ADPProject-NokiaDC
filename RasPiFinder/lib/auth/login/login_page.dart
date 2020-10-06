import 'package:RasPiFinder/auth/signup/signup_page.dart';
import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/components/password_input_field.dart';
import 'package:RasPiFinder/components/rounded_button.dart';
import 'package:RasPiFinder/components/signup_signin_check.dart';
import 'package:RasPiFinder/components/text_input_field.dart';
import 'package:RasPiFinder/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  LoginForm createState() => new LoginForm();
}

class LoginForm extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String userName, password;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: piAppBar,
      backgroundColor: Colors.white,
      body: Card(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextInputField(
                hintText: "Username",
                icon: Icons.person,
                onChanged: (value) {
                  userName = value;
                },
                validateInput: validateUsernameInput,
              ),
              PasswordInputField(
                onChanged: (value) {
                  password = value;
                },
                validateInput: validatePasswdInput,
              ),
              RoundedButton(
                text: "Sign In",
                //TODO connect to DB to store user credentials and status
                press: () {
                  submit();
                },
              ),
              SizedBox(height: size.height * 0.03),
              SignupSigninCheck(
                press: () {
                  navigateToPage(context, SignupPage());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String validateUsernameInput(String username) {
    if (null == userName || username.isEmpty) {
      return 'Please enter username !';
    }
    return null;
  }

  String validatePasswdInput(String username) {
    if (null == password || password.isEmpty) {
      return 'Please enter password !';
    }
    return null;
  }

  void submit(){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      //TODO get current GPS data and store to DB
      //TODO connect to DB to store user input
      print(userName);
      print(password);
      navigateToPage(context, HomePage());
    }
  }
}
