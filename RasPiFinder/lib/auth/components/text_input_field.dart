import 'package:RasPiFinder/auth/components/text_field_container.dart';
import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const TextInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.blue,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
