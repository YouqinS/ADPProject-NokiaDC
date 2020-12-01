import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/wrapper.dart';
import 'package:RasPiFinder/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'onboarding/onboarding.dart';
import 'onboarding/sharedPreferences.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(RasPiFinder());
// }

// class RasPiFinder extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<MUser>.value (
//         value:  AuthenticationService().user,
//         child: MaterialApp(
//         home: Wrapper(),
//       ),
//     );
//   }
// }

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