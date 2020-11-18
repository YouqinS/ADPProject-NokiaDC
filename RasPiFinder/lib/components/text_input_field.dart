import 'package:RasPiFinder/components/text_field_container.dart';
import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final FormFieldSetter<String> onSaved;
  final FormFieldSetter<String> onChanged;
  final FormFieldValidator<String> validateInput;

  TextInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onSaved,
    this.validateInput,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onSaved: onSaved,
        onChanged: onChanged,
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
