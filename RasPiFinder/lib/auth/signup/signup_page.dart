import 'package:RasPiFinder/auth/login/login_page.dart';
import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/components/password_input_field.dart';
import 'package:RasPiFinder/components/rounded_button.dart';
import 'package:RasPiFinder/components/signup_signin_check.dart';
import 'package:RasPiFinder/components/text_input_field.dart';
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
  String username, email, phone, password;
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
                onSaved: (value) {
                  username = value;
                },
                validateInput: validateUsernameInput,
              ),
              TextInputField(
                hintText: "Email",
                icon: Icons.email,
                onSaved: (value) {
                  email = value;
                },
                validateInput: validateEmailInput,
              ),
              TextInputField(
                hintText: "Phone Number",
                icon: Icons.phone_android,
                onSaved: (value) {
                  phone = value;
                },
                validateInput: validatePhoneInput,
              ),
              PasswordInputField(
                onSaved: (value) {
                  password = value;
                },
                validateInput: validatePasswdInput,
              ),
              RoundedButton(
                text: "Sign Up",
                //TODO connect to DB to store user credentials and status
                press: () {
                  submit();
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
        )
      ),
    );
  }

  String validateUsernameInput(String username) {
    if (null == username || username.isEmpty) {
      return 'Please enter username !';
    }
    return null;
  }

  String validateEmailInput(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (null == email || email.isEmpty || !regex.hasMatch(email)) {
      return 'Please enter a valid email !';
    }
    return null;
  }

  String validatePhoneInput(String phone) {
    if (null == phone || phone.isEmpty) {
      return 'Please enter phone number !';
    }
    return null;
  }

  String validatePasswdInput(String password) {
    if (null == password || password.isEmpty) {
      return 'Please enter password !';
    }
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(password)) {
      return 'Password needs to contain at least 8 characters,\n'
          'with at least one big letter, one small letter,\n'
          'one special character and one number!';
    }
    return null;
  }

  void submit(){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      //TODO get current GPS data and store to DB
      //TODO connect to DB to store user input
      print(username);
      print(phone);
      print(email);
      print(password);
      navigateToPage(context, HomePage());
    }
  }
}
