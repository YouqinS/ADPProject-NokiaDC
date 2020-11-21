import 'package:flutter/material.dart';

class Validator {

  static String validateUsername(String username) {
    if (username== null || username.isEmpty || username.length < 4) {
      return 'Min length: 4';
    }
    return null;
  }

  static String validateEmailInput(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (null == email || email.isEmpty || !regex.hasMatch(email)) {
      return 'Invalid email';
    }
    return null;
  }

  static String validatePhoneInput(String phone) {
    if (null == phone || phone.isEmpty || double.tryParse(phone) == null) {
      return 'Invalid phone number!';
    } else if (phone.length < 7) {
      return 'Min length: 7';
    }
    return null;
  }

  static String validatePasswdInput(String password) {
    if (null == password || password.isEmpty) {
      return 'Password empty';
    }
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(password)) {
      return 'e.g.: 123Abc!#';
    }
    return null;
  }

  static   String confirmPasswdInput(String password, String password2) {
    if (null != password && password.isNotEmpty && password != password2) {
      return 'Passwords do not match!';
    }
    return null;
  }


  static Future<void> showAlert(BuildContext context, String title, String bodyText, String btnText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(bodyText),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(btnText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}