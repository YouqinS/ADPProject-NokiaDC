import 'package:RasPiFinder/auth/Validator.dart';
import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/components/password_input_field.dart';
import 'package:RasPiFinder/components/rounded_button.dart';
import 'package:RasPiFinder/components/text_input_field.dart';
import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/profile/profile.dart';
import 'package:RasPiFinder/services/authentication_service.dart';
import 'package:RasPiFinder/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  final UserData userData;
  Settings({Key key, this.userData}) : super(key: key);

  @override
  SettingsState createState() => new SettingsState(userData);
}

class SettingsState extends State<Settings> {
  final UserData userData;
  String username, email, phone, password, currentEmail, currentPassword;
  SettingsState(this.userData) {
    currentEmail = userData.email;
    email = userData.email;
    username = userData.username;
    phone = userData.phoneNumber;
  }

  final basicFormKey = GlobalKey<FormState>();
  final authFormKey = GlobalKey<FormState>();
  final AuthenticationService _authenticationService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PiAppBar(title: 'Settings').build(context),
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.blue[100],
                      child: Icon(
                        Icons.person,
                        color: Colors.blue[900],
                        size: size.height * 0.1,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.05,
                    ),
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Card(
                  elevation: 0,
                  color: Colors.grey[100],
                  child: Form(
                    key: basicFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Update basic information',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        TextInputField(
                          hintText: "Username",
                          icon: Icons.person,
                          initialValue: username,
                          onSaved: (value) {
                            username = value;
                          },
                          validateInput: validateUsernameInput,
                        ),
                        TextInputField(
                          hintText: "New Phone Number",
                          icon: Icons.phone_android,
                          initialValue: phone,
                          onSaved: (value) {
                            phone = value;
                          },
                          validateInput: validatePhoneInput,
                        ),
                        RoundedButton(
                          text: "Save",
                          press: () {
                            submitBasicInfo();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 0,
                  color: Colors.grey[100],
                  child: Form(
                    key: authFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Update authentication information',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        TextInputField(
                          hintText: "New Email",
                          icon: Icons.email,
                          initialValue: email,
                          onSaved: (value) {
                            email = value;
                          },
                          validateInput: validateEmailInput,
                        ),
                        PasswordInputField(
                          hintText: 'Current Password',
                          onChanged: (value) {
                            currentPassword = value;
                          },
                          onSaved: (value) {
                            currentPassword = value;
                          },
                          validateInput: validatePasswdInput,
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
                            password = value;
                          },
                          validateInput: confirmPasswdInput,
                        ),
                        RoundedButton(
                          text: "Save",
                          press: () {
                            submitAuthInfo();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  String validateUsernameInput(String username) {
    return username != null && username != '' ? null : 'Invalid username';
  }

  String validateEmailInput(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (null != email && email.isNotEmpty && !regex.hasMatch(email)) {
      return 'Please enter a valid email !';
    }
    return null;
  }

  String validatePasswdInput(String password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (null != password && password.isNotEmpty && !regExp.hasMatch(password)) {
      return 'Password needs to contain at least 8 characters,\n'
          'with at least one big letter, one small letter,\n'
          'one special character and one number!';
    }
    return null;
  }

  String confirmPasswdInput(String password2) {
    if (null != password && password.isNotEmpty && password != password2) {
      return 'Passwords do not match!';
    }
    return null;
  }

  String validatePhoneInput(String phone) {
    if (null != phone && phone.isNotEmpty && phone.length < 10) {
      return 'A valid Finnish phone number contains at least 10 numbers!';
    }
    return null;
  }

  void submitBasicInfo() async {
    if (basicFormKey.currentState.validate()) {
      basicFormKey.currentState.save();
      try {
        //TODO get current GPS data and store to DB
        await DatabaseService(uid: userData.uid)
            .updateUserData(username, null, phone);
        Validator.showAlert(
            context, "Success", "Your changes have been saved", "OK");
      } on FirebaseAuthException catch (e) {
        print(e.toString());
      }
    }
  }

  void submitAuthInfo() async {
    if (authFormKey.currentState.validate()) {
      authFormKey.currentState.save();
      try {
        await _authenticationService.updateEmailPassword(
            userData.uid, currentEmail, currentPassword, email, password);
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        print(e.toString());
        Validator.showAlert(context, "Alert", "Wrong current password", "OK");
      }
    }
  }
}
