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
      flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: new LinearGradient(
              colors: <Color>[
                const Color(0xFF124191),
                const Color(0xFF124191),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.8, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp              
            ),
          ),
        ),
      // backgroundColor: Colors.blue,
      centerTitle: true,
      actions: <Widget>[],
    );
  }
}
