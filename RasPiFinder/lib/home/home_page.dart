import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(
        "RasPiFinder",
        style: TextStyle(
        color: Colors.white,
        letterSpacing: 2,
        fontWeight: FontWeight.bold,
        fontSize: 20
    ),
    ),
    backgroundColor: Colors.blue,
    centerTitle: true,
    ),
    backgroundColor: Colors.white,
    body: Center(
      child: Text("This is the dummy home page"),
    ),
    );
  }
}
