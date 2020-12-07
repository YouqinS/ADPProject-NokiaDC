import 'package:flutter/material.dart';

class RaspPiText extends StatefulWidget {
  @override
  _RaspPiTextState createState() => _RaspPiTextState();
}

class _RaspPiTextState extends State<RaspPiText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0, left: 10.0),
      child: Container(
        height: 200,
        width: 200,
        child: Column(
          children: <Widget>[
            Container(
              height: 30,
            ),
            Center(
              child: Text(
                'A world of possibilities in an app',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}