import 'package:RasPiFinder/screens/components/loading.dart';
import 'package:RasPiFinder/screens/components/password_input_field.dart';
import 'package:RasPiFinder/screens/components/raspFiText.dart';
import 'package:RasPiFinder/screens/components/rounded_button.dart';
import 'package:RasPiFinder/screens/components/signup_signin_check.dart';
import 'package:RasPiFinder/screens/components/text_input_field.dart';
import 'package:RasPiFinder/screens/components/verticalText.dart';
import 'package:RasPiFinder/services/authentication_service.dart';
import 'package:RasPiFinder/widgets/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Validator.dart';

class LoginPage extends StatefulWidget {
  final Function toggle;
  LoginPage({this.toggle});

  @override
  LoginForm createState() => new LoginForm();
}

class LoginForm extends State<LoginPage> {
  final AuthenticationService _authenticationService = AuthenticationService();
  final formKey = GlobalKey<FormState>();
  String email, password, error;
  bool loading = false;

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
        loading
        ? Loading()
        : Scaffold(
            // appBar: PiAppBar(title: 'RasPiFinder').build(context),
            backgroundColor: Colors.transparent,
            body: new GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child:SingleChildScrollView(
                child: Container (
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        VerticalText(),
                        RaspPiText()
                      ]),
                      Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: size.height * 0.17),
                            TextInputField(
                              hintText: "Email",
                              icon: Icons.email,
                              onSaved: (value) {
                                email = value.trim();
                              },
                              validateInput: (email) =>
                                  Validator.validateEmailInput(email.trim()),
                            ),
                            PasswordInputField(
                              hintText: "Password",
                              onSaved: (value) {
                                password = value;
                              },
                              validateInput: (password) =>
                                  Validator.validatePasswdInput(password),
                            ),
                            RoundedButton(
                              color: AppTheme.text,
                              text: "Sign In",
                              press: () async {
                                submit();
                              },
                            ),
                            SizedBox(height: size.height * 0.01),
                            SignupSigninCheck(
                              press: () {
                                widget.toggle();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future submit() async {
    if (formKey.currentState.validate()) {
      setState(() => loading = true);
      formKey.currentState.save();
      dynamic result = await _authenticationService.signInWithEmailAndPassword(
          email, password);
      if (result == null) {
        setState(() {
          loading = false;
        });
        Validator.showAlert(context, "Alert", "Wrong email or password", "OK");
      }
    }
  }
}
