import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BackButtonPress extends StatefulWidget{

  @override
  _BackButtonPressState createState() => _BackButtonPressState();
}

class _BackButtonPressState extends State<BackButtonPress> {

  DateTime backButtonPressTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Center(child: Text("Double click to exit the app."),),
      ),
    );
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    //if backButton has not been pressed or toast has been closed
    bool backButton = backButtonPressTime == null || currentTime.difference(backButtonPressTime) > Duration(seconds: 3);

    if (backButton) {
      backButtonPressTime = currentTime;
      Fluttertoast.showToast(msg: "Double click to exit the app.");
      return false;
    }
    return true;
  }
}
  
