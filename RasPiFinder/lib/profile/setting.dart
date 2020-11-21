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
  bool showUsernameField = false, showEmailField = false, showPhoneField = false, showPassField = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PiAppBar(title: 'Settings').build(context),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.01,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue[100],
                    child: Icon(
                      Icons.person,
                      color: Colors.blue[900],
                      size: size.height * 0.1,
                    ),
                  ),

                  SizedBox(width: size.width * 0.05,),
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
              SizedBox(height: size.height * 0.05,),
              FlatButton(onPressed: usernamePressed, child: Text('update username'), color: Colors.grey[200],),
              Visibility(
                visible: showUsernameField,
                child: TextInputField(
                  hintText: "New Username",
                  icon: Icons.person,
                  onSaved: (value) {
                    username = value.trim();
                  },
                  validateInput: validateUsername,
                ),
              ),
              FlatButton(onPressed: emailPressed, child: Text('update email'), color: Colors.grey[200],),
              Visibility(
                visible: showEmailField,
                child: TextInputField(
                  hintText: "New Email",
                  icon: Icons.email,
                  onSaved: (value) {
                    email = value.trim();
                  },
                  validateInput: validateEmailInput,
                ),
              ),
              FlatButton(onPressed: phonePressed, child: Text('update phone'), color: Colors.grey[200],),
              Visibility(
                visible: showPhoneField,
                child: TextInputField(
                  hintText: "New Phone Number",
                  icon: Icons.phone_android,
                  onSaved: (value) {
                    phone = value.trim();
                  },
                  validateInput: validatePhoneInput,
                ),
              ),
              FlatButton(onPressed: passwordPressed, child: Text('update password'), color: Colors.grey[200],),
              Visibility(
                visible: showPassField,
                child: Column(
                  children: [
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
                        password2 = value.trim();
                      },
                      validateInput: (password2) => Validator.confirmPasswdInput(password, password2),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Visibility(
                visible: showPassField || showUsernameField || showPhoneField || showEmailField,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      color: Colors.red[600],
                      child: Text('Cancel',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    RaisedButton(
                      color: Colors.blue[700],
                      child: Text('Save',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        submit();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02,),
            ],
          ),
        ),
      ),
    );
  }

  void usernamePressed() {
    setState(() {
      showUsernameField = !showUsernameField;
    });

    if(!showUsernameField) {
      setState(() {
        username = null;
      });
    }
  }
  void emailPressed() {
    setState(() {
      showEmailField = !showEmailField;
    });

    if(!showEmailField) {
      setState(() {
        email = null;
      });
    }
  }
  void phonePressed() {
    setState(() {
      showPhoneField = !showPhoneField;
    });
    if(!showPhoneField) {
      setState(() {
        phone = null;
      });
    }
  }
  void passwordPressed() {
    setState(() {
      showPassField = !showPassField;
    });
    if(!showPassField) {
      setState(() {
        password = null;
        password2 = null;
      });
    }
  }
  String validateEmailInput(String email) {
    if (null != email && email.isNotEmpty) {
      return Validator.validateEmailInput(email.trim());
    }
    return null;
  }

  String validatePasswdInput(String password) {
    if (null != password && password.isNotEmpty) {
      return Validator.validatePasswdInput(password.trim());
    }
    return null;
  }

  String validatePhoneInput(String phone) {
    if (null != phone && phone.isNotEmpty) {
      return Validator.validatePhoneInput(phone.trim());
    }
    return null;
  }

  String validateUsername(String username) {
    if (username != null && username.isNotEmpty) {
      return Validator.validateUsername(username.trim());
    }
    return null;
  }

  void submit(){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      //TODO connect to DB to store user input
      print(username);
      print(phone);
      print(email);
      print(password);

      if (noInput(username) &&  noInput(phone) && noInput(email) && noInput(password)) {
        Validator.showAlert(context, 'Alert', 'No input for update', 'OK');
      }
     // navigateToPage(context, HomePage());
    }
  }

  bool noInput(String input) {
    return null == input || input.isEmpty;
  }
}
