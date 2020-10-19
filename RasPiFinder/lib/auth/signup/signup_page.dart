import 'package:RasPiFinder/components/password_input_field.dart';
import 'package:RasPiFinder/components/rounded_button.dart';
import 'package:RasPiFinder/components/signup_signin_check.dart';
import 'package:RasPiFinder/components/text_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/services/authentication_service.dart';
import 'package:RasPiFinder/components/loading.dart';
import 'package:RasPiFinder/components/app_bar.dart';


class SignupPage extends StatefulWidget {
  final Function toggle;
  SignupPage({this.toggle});
  // SignupPage({Key key}) : super(key: key);

  @override
  SignupForm createState() => new SignupForm();
}

class SignupForm extends State<SignupPage> {

  final AuthenticationService _authenticationService = AuthenticationService();

  bool loading = false;
  final formKey = GlobalKey<FormState>();
  String username, email, phone, password;
  String error = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading ? Loading() : Scaffold(
      appBar: PiAppBar(title: 'RasPiFinder').build(context),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Card(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
                validateInput: (val) => val.length < 6 ? 'Enter a password more than 6 characters' : null,
              ),
              RoundedButton(
                text: "Sign Up",
                press: () async {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        setState(() => loading = true);
                        dynamic result = await _authenticationService.registerWithEmailAndPassword(email, password);
                        if (result == null) {
                            setState(() {
                              error = 'Please supply a valid email';
                              loading = false;                             
                              } 
                            );                 
                        }
                      }                
                },
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              SizedBox(height: size.height * 0.02),
              SignupSigninCheck(
                login: false,
                press: () {
                  widget.toggle();
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
}