import 'package:RasPiFinder/screens/auth/components/text_field_container.dart';
import 'package:flutter/material.dart';

class PasswordInputField extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validateInput;

  PasswordInputField({
    Key key,
    this.onSaved,
    this.validateInput,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: true,
        onSaved: onSaved,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: Colors.blue,
          ),
          border: InputBorder.none,
        ),
        validator: validateInput,
      ),
    );
  }
}