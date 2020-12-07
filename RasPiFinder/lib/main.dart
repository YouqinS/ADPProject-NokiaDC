import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/screens/onboarding/onboarding.dart';
import 'package:RasPiFinder/screens/onboarding/sharedPreferences.dart';
import 'package:RasPiFinder/services/authentication_service.dart';
import 'package:RasPiFinder/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(RasPiFinder());
}

class RasPiFinder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RasPiFinderState();
  }
}

class RasPiFinderState extends State<RasPiFinder> {
  // This widget is the root of your application.
  bool isFirstTimeOpen = false;
 
  RasPiFinderState() {
    MSharedPreferences.instance
        .getBooleanValue("firstTimeOpen")
        .then((value) => setState(() {
              isFirstTimeOpen = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MUser>.value (
        value:  AuthenticationService().user,
        child: MaterialApp(
        home: isFirstTimeOpen ?  Wrapper(): OnBoardingPage() ,
      ),
    );
  }
}