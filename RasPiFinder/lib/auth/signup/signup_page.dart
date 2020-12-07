import 'package:RasPiFinder/auth/Validator.dart';
import 'package:RasPiFinder/components/password_input_field.dart';
import 'package:RasPiFinder/components/raspFiText.dart';
import 'package:RasPiFinder/components/rounded_button.dart';
import 'package:RasPiFinder/components/signup_signin_check.dart';
import 'package:RasPiFinder/components/text_input_field.dart';
import 'package:RasPiFinder/components/verticalText.dart';
import 'package:RasPiFinder/widgets/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/services/authentication_service.dart';

class SignupPage extends StatefulWidget {
  final Function toggle;
  SignupPage({this.toggle});

  @override
  SignupForm createState() => new SignupForm();
}

class SignupForm extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final AuthenticationService _authenticationService = AuthenticationService();
  bool loading = false;
  String username, email, phone, password;
  String error = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(4, 9, 35, 1),
                Color.fromRGBO(39, 105, 171, 1),
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            ),
          ),
        ),
        Scaffold(
          // appBar: PiAppBar(title: 'RasPiFinder').build(context),
          backgroundColor: Colors.transparent,
          body: new GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
              child: Container (
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        VerticalText(),
                        RaspPiText()
                        ],
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: size.height * 0.04),
                            TextInputField(
                              hintText: "Username",
                              icon: Icons.person,
                              onSaved: (value) {
                                username = value;
                              },
                              validateInput: (username) => Validator.validateUsername(username.trim()),
                            ),
                            TextInputField(
                              hintText: "Email",
                              icon: Icons.email,
                              onSaved: (value) {
                                email = value.trim();
                              },
                              validateInput: (email) => Validator.validateEmailInput(email.trim()),
                            ),
                            TextInputField(
                              hintText: "Phone Number",
                              icon: Icons.phone_android,
                              onSaved: (value) {
                                phone = value;
                              },
                              validateInput: (phone) => Validator.validatePhoneInput(phone.trim()),
                            ),
                            PasswordInputField(
                              hintText: "Password",
                              onSaved: (value) {
                                password = value;
                              },
                              validateInput: (password) => Validator.validatePasswdInput(password),
                            ),
                            RoundedButton(
                              color: AppTheme.text,
                              text: "Sign Up",
                              press: () async {
                                submit();
                              },
                            ),
                            SizedBox(height: size.height * 0.01),
                            Text(
                              error,
                              style: TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
                            SizedBox(height: size.height * 0.01),
                            SignupSigninCheck(
                              login: false,
                              press: () {
                                widget.toggle();
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
            ), 
            ),
          ),
        ),
        // ),
      ],
    );
  }

  Future<void> submit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print(username);
      print(phone);
      print(email);
      print(password);

      setState(() => loading = true);
      dynamic result = await _authenticationService
          .registerWithEmailAndPassword(email, password, username, phone);
      if (result == null) {
        setState(() {
          error = 'Email already used!';
          loading = false;
        });
      }
    }
  }
}