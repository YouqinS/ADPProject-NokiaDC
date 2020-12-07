import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/screens/auth/authenticate.dart';
import 'package:RasPiFinder/screens/onboarding/sharedPreferences.dart';
import 'package:RasPiFinder/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:RasPiFinder/navigation_screen.dart';

import 'models/rasps.dart';

class Wrapper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WrapperState();
  }
}

class WrapperState extends State<Wrapper> {

  bool isFirstTimeOpen = true;
 
  WrapperState() {
    print("First time");
    print(isFirstTimeOpen);
    MSharedPreferences.instance
        .getBooleanValue("firstTimeOpen")
        .then((value) => setState(() {
              isFirstTimeOpen = value;
            }));
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MUser>(context);
    print("First time22");
    print(isFirstTimeOpen);

    if ( user == null) {
      return Authenticate();
    }
    else {
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
