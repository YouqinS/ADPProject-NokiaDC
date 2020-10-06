import 'package:RasPiFinder/components/text_field_container.dart';
import 'package:flutter/material.dart';

class PasswordInputField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  String userInput = '';
  final FormFieldValidator<String> validateInput;

  PasswordInputField({
    Key key,
    this.onChanged,
    this.validateInput,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: Colors.blue,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: Colors.blue,
          ),
          border: InputBorder.none,
        ),
        onSaved: (input) => userInput = input,
        validator: validateInput,
      ),
    );
  }
}
