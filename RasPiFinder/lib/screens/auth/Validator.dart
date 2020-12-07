import 'package:flutter/material.dart';

class Validator {
  static String validateUsername(String username) {
    if (username == null || username.isEmpty || username.length < 4) {
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

  static String validatePasswdInput(String password, {bool isRequired = true}) {
    if ((null == password || password.isEmpty) && isRequired) {
      return 'Password empty';
    } else if (password != null && password.isNotEmpty) {
      if (password.length < 8) {
        return 'min length: 8';
      }
      String pattern = r'(?=.*[A-Z])';
      RegExp regExp = new RegExp(pattern);

      if (!regExp.hasMatch(password)) {
        return 'require at least one uppercase';
      }

      pattern = r'(?=.*[a-z])';
      regExp = new RegExp(pattern);
      if (!regExp.hasMatch(password)) {
        return 'require at least one lowercase';
      }

      pattern = r'(?=.*?[0-9])';
      regExp = new RegExp(pattern);
      if (!regExp.hasMatch(password)) {
        return 'require at least one number';
      }

      pattern = r'(?=.*?[!@#\$&*~]).{8,}';
      regExp = new RegExp(pattern);
      if (!regExp.hasMatch(password)) {
        return 'require at least one special character';
      }
      return null;
    }
    return null;
  }

  static Future<void> showAlert(BuildContext context, String title,
      String bodyText, String btnText) async {
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
