import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PiAppBar extends StatelessWidget {
  final String title;

  const PiAppBar({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
       title,
        style: TextStyle(
            color: Colors.white,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            fontSize: 20
        ),
      ),
      backgroundColor: Colors.blue,
      centerTitle: true,
    );
  }
}
