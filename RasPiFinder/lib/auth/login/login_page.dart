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
      body: Card(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
               TextInputField(
                hintText: "Email",
                icon: Icons.person,
                onSaved: (value) {
                  email = value;
                },
                validateInput: (val) => val.isEmpty ? 'Enter an email' : null,
              ),
              PasswordInputField(
                onSaved: (value) {
                  password = value;
                },
                validateInput: (val) => val.length < 6 ? 'Enter a password more than 6 characters' : null,
              ),
              RoundedButton(
                text: "Sign In",
                press: () async {
                  if (formKey.currentState.validate()) {
                    setState(() => loading = true);
                    formKey.currentState.save();
                    dynamic result = await _authenticationService.signInWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() {
                        error = 'Could not sign in with the credentials';
                        loading = false;
                      });                      
                    }
                  }
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
    );
  }
}