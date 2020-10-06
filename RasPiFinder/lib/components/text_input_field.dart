import 'package:RasPiFinder/components/text_field_container.dart';
import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final String hintText;
  String userInput = '';
  final IconData icon;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validateInput;

  TextInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
    this.validateInput,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.blue,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
        onSaved: (input) => userInput = input,
        validator: validateInput,
      ),
    );
  }
}
