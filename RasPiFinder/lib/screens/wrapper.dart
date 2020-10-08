import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/screens/auth/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:RasPiFinder/screens/navigation_screen.dart';

class  Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<MUser>(context);

    //return either home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return NavigationPage();    
    }
  }
}