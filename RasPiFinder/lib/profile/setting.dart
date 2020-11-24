import 'package:RasPiFinder/auth/Validator.dart';
import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/password_input_field.dart';
import 'package:RasPiFinder/components/rounded_button.dart';
import 'package:RasPiFinder/components/text_input_field.dart';
import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/services/authentication_service.dart';
import 'package:RasPiFinder/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  final formKey = GlobalKey<FormState>();
  final AuthenticationService _authenticationService = AuthenticationService();

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
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextInputField(
                        hintText: "New Email",
                        icon: Icons.email,
                        initialValue: email,
                        onSaved: (value) {
                          email = value;
                        },
                        validateInput: validateEmailInput,
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
                      PasswordInputField(
                        hintText: 'Old Password',
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
                        //TODO connect to DB to store user credentials and status
                        press: () {
                          submit();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  void submit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      try {
        //TODO get current GPS data and store to DB
        await DatabaseService(uid: userData.uid)
            .createOrEditUser(username, email, phone);
        await _authenticationService.updateEmailPassword(
            currentEmail, currentPassword, email, password);
        if (password != null) {
          await _authenticationService.signOut();
        }
      } on FirebaseAuthException catch (e) {
        print(e.toString());
        Validator.showAlert(context, "Alert", "Wrong current password", "OK");
      }
    }
  }
}
