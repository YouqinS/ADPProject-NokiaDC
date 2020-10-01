import 'package:RasPiFinder/components/text_field_container.dart';
import 'package:flutter/material.dart';

class PasswordInputField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const PasswordInputField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
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
      ),
    );
  }
}
