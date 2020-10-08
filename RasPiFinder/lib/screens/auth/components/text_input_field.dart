import 'package:RasPiFinder/screens/auth/components/text_field_container.dart';
import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validateInput;

  TextInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onSaved,
    this.validateInput,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onSaved: onSaved,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.blue,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
        validator: validateInput,
      ),
    );
  }
}
