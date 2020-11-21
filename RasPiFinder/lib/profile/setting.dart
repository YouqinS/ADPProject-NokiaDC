import 'package:RasPiFinder/auth/Validator.dart';
import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/components/password_input_field.dart';
import 'package:RasPiFinder/components/rounded_button.dart';
import 'package:RasPiFinder/components/text_input_field.dart';
import 'package:RasPiFinder/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  SettingsState createState() => new SettingsState();
}

class SettingsState extends State<Settings> {
  final formKey = GlobalKey<FormState>();
  String username, email, phone, password, password2;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PiAppBar(title: 'Settings').build(context),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[100],
          width: size.width,
          height: size.height,
          child: Card(
            elevation: 0,
            color: Colors.grey[100],
            child:  Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 22,
                    ),
                  ),
                  TextInputField(
                    hintText: "New Username",
                    icon: Icons.person,
                    onSaved: (value) {
                      username = value;
                    },
                    validateInput: validateUsername,
                  ),
                  TextInputField(
                    hintText: "New Email",
                    icon: Icons.email,
                    onSaved: (value) {
                      email = value;
                    },
                    validateInput: validateEmailInput,
                  ),
                  TextInputField(
                    hintText: "New Phone Number",
                    icon: Icons.phone_android,
                    onSaved: (value) {
                      phone = value;
                    },
                    validateInput: validatePhoneInput,
                  ),
                  PasswordInputField(
                    hintText: 'New Password',
                    onChanged: (value) {
                      password = value;
                    },
                    onSaved: (value) {
                      password = value;
                    },
                    validateInput: validatePasswdInput,
                  ),
                  PasswordInputField(
                    hintText: 'Confirm Password',
                    onSaved: (value) {
                      password2 = value;
                    },
                    validateInput: (password2) => Validator.confirmPasswdInput(password, password2),
                  ),
                  RoundedButton(
                    text: "Save",
                    //TODO connect to DB to store user credentials and status
                    press: () {
                      submit();
                    },
                  ),
                ],
              ),
            ),

          ),
        ),
      ),
    );
  }

  String validateEmailInput(String email) {
    if (null != email && email.isNotEmpty) {
      return Validator.validateEmailInput(email);
    }
    return null;
  }

  String validatePasswdInput(String password) {
    if (null != password && password.isNotEmpty) {
      return Validator.validatePasswdInput(password);
    }
    return null;
  }

  String validatePhoneInput(String phone) {
    if (null != phone && phone.isNotEmpty) {
      return Validator.validatePhoneInput(phone);
    }
    return null;
  }

  String validateUsername(String username) {
    if (username != null && username.isNotEmpty) {
      return Validator.validateUsername(username);
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
     // navigateToPage(context, HomePage());
    }
  }
}
