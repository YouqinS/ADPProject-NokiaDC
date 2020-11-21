import 'package:RasPiFinder/auth/Validator.dart';
import 'package:RasPiFinder/components/signup_signin_check.dart';
import 'package:RasPiFinder/components/rounded_button.dart';
import 'package:RasPiFinder/components/text_input_field.dart';
import 'package:RasPiFinder/components/password_input_field.dart';
import 'package:RasPiFinder/services/authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/components/loading.dart';
import 'package:RasPiFinder/components/app_bar.dart';


class LoginPage extends StatefulWidget {

  final Function toggle;
  LoginPage({ this.toggle });
  // LoginPage({Key key}) : super(key: key);

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
    return loading ? Loading() : Scaffold(
      appBar: PiAppBar(title: 'RasPiFinder').build(context),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Card(
          elevation: 0,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.1),
                TextInputField(
                  hintText: "Email",
                  icon: Icons.email,
                  onSaved: (value) {
                    email = value.trim();
                  },
                  validateInput: (email) => Validator.validateEmailInput(email.trim()),
                ),
                PasswordInputField(
                  onSaved: (value) {
                    password = value.trim();
                  },
                  validateInput: (password) => Validator.validatePasswdInput(password.trim()),
                ),
                RoundedButton(
                  text: "Sign In",
                  press: () async {
                    submit();
                  },
                ),
                SizedBox(height: size.height * 0.03),
                SignupSigninCheck(
                  press: () {
                    // navigateToPage(context, SignupPage());
                    widget.toggle();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future submit() async {
    if (formKey.currentState.validate()) {
      setState(() => loading = true);
      formKey.currentState.save();
      dynamic result = await _authenticationService.signInWithEmailAndPassword(email, password);
      if (result == null) {
        setState(() {
          loading = false;
        });
        Validator.showAlert(context, "Alert", "Wrong email or password", "OK");
      }
    }
  }
}