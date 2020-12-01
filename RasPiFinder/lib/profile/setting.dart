import 'package:RasPiFinder/auth/Validator.dart';
import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/password_input_field.dart';
import 'package:RasPiFinder/components/rounded_button.dart';
import 'package:RasPiFinder/components/text_input_field.dart';
import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/services/authentication_service.dart';
import 'package:RasPiFinder/services/database.dart';
import 'package:RasPiFinder/widgets/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final UserData userData;
  SettingsPage({Key key, this.userData}) : super(key: key);

  @override
  SettingsPageState createState() => new SettingsPageState(userData);
}

class SettingsPageState extends State<SettingsPage> with AutomaticKeepAliveClientMixin {
  bool viewVisible = false ;
  String mText = "Update authenticate information >";
  final UserData userData;
  String username, email, phone, password, currentEmail, currentPassword;
  SettingsPageState(this.userData) {
    currentEmail = userData.email;
    email = userData.email;
    username = userData.username;
    phone = userData.phoneNumber;
  }

  final basicFormKey = GlobalKey<FormState>();
  final authFormKey = GlobalKey<FormState>();
  final AuthenticationService _authenticationService = AuthenticationService();

  void showWidget(){
    setState(() {
     viewVisible = true ; 
    });
  }
 
  void hideWidget(){
    setState(() {
     viewVisible = false ; 
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue[100],
                        child: Icon(
                          Icons.person,
                          color: Colors.blue[900],
                          size: size.height * 0.1,
                        ),
                      ),
                    ),
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: AppTheme.text,
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
                  color: Colors.grey[50],
                  child: Form(
                    key: basicFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Update basic information',
                          style: TextStyle(
                            color: AppTheme.text,
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
                          validateInput: (username) =>
                              Validator.validateUsername(username.trim()),
                        ),
                        TextInputField(
                          hintText: "New Phone Number",
                          icon: Icons.phone_android,
                          initialValue: phone,
                          onSaved: (value) {
                            phone = value;
                          },
                          validateInput: (phone) =>
                              Validator.validatePhoneInput(phone.trim()),
                        ),
                        RoundedButton(
                          color: AppTheme.text,
                          text: "Save",
                          press: () {
                            submitBasicInfo();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child:Container(
                    child: Column(
                      children: <Widget>[
                        FlatButton(
                          color: Colors.transparent,
                          onPressed: _visibilitymethod , child: new Text(mText,
                                      style: TextStyle(
                                        color: AppTheme.text,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                        ),
                        Visibility(
                          maintainSize: true, 
                          maintainAnimation: true,
                          maintainState: true,
                          visible: viewVisible, 
                          child: Card(
                            elevation: 0,
                            color: Colors.grey[50],
                            child: Form(
                              key: authFormKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextInputField(
                                    hintText: "New Email",
                                    icon: Icons.email,
                                    initialValue: email,
                                    onSaved: (value) {
                                      email = value;
                                    },
                                    validateInput: (email) =>
                                        Validator.validateEmailInput(email.trim()),
                                  ),
                                  PasswordInputField(
                                    hintText: 'Current Password',
                                    onChanged: (value) {
                                      currentPassword = value;
                                    },
                                    onSaved: (value) {
                                      currentPassword = value;
                                    },
                                    validateInput: (password) =>
                                        Validator.validatePasswdInput(password),
                                  ),
                                  PasswordInputField(
                                    hintText: 'New Password',
                                    onChanged: (value) {
                                      password = value;
                                    },
                                    onSaved: (value) {
                                      password = value;
                                    },
                                    validateInput: (password) =>
                                        Validator.validatePasswdInput(password,
                                            isRequired: false),
                                  ),
                                  PasswordInputField(
                                    hintText: 'Confirm Password',
                                    onSaved: (value) {
                                      password = value;
                                    },
                                    validateInput: confirmPasswdInput,
                                  ),
                                  RoundedButton(
                                    color: AppTheme.text,
                                    text: "Save",
                                    press: () {
                                      submitAuthInfo();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                  )
                ),
              ],
            ),
          )),
    );
  }

  String confirmPasswdInput(String password2) {
    if (null != password && password.isNotEmpty && password != password2) {
      return 'Passwords do not match!';
    }
    return null;
  }

  void submitBasicInfo() async {
    if (basicFormKey.currentState.validate()) {
      basicFormKey.currentState.save();
      try {
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

  void _visibilitymethod() {
    setState(() {
      if (viewVisible) {
        hideWidget();
        mText = "Update authenticate information >";
      } else {
        showWidget();
        mText = "Update authenticate information";
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
