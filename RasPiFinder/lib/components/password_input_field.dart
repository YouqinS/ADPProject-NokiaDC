import 'package:RasPiFinder/components/text_field_container.dart';
import 'package:flutter/material.dart';

class PasswordInputField extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validateInput;
  final String hintText;

  PasswordInputField({
    Key key,
    this.onSaved,
    this.validateInput,
    this.hintText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: true,
        onSaved: onSaved,
        onChanged: onChanged,
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