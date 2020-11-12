import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/auth/authenticate.dart';
import 'package:RasPiFinder/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:RasPiFinder/navigation_screen.dart';

import 'models/rasps.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MUser>(context);

    //return either home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      print('Wrapper user uid=' + user.uid);
      return MultiProvider(
          providers: [
          StreamProvider<List<Rasp>>.value(value: DatabaseService().rasps),
          StreamProvider<List<UserData>>.value(value: DatabaseService().users),
          StreamProvider<UserData>.value(value: DatabaseService(uid: user.uid).userData)],
          child: NavigationPage());
    }
  }
}
