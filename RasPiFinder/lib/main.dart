import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/onboarding/onboarding.dart';
import 'package:RasPiFinder/wrapper.dart';
import 'package:RasPiFinder/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:RasPiFinder/onboarding/sharedPreferences.dart';

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

// void main() {
//   runApp(RasPiFinder());
// }

// class RasPiFinder extends StatefulWidget {
//   _RasPiFinderState createState() => _RasPiFinderState();
// }

// class _RasPiFinderState extends State<RasPiFinder> {
//   // Set default `_initialized` and `_error` state to false
//   bool _initialized = false;
//   bool _error = false;

//   // Define an async function to initialize FlutterFire
//   void initializeFlutterFire() async {
//     try {
//       // Wait for Firebase to initialize and set `_initialized` state to true
//       await Firebase.initializeApp();
//       setState(() {
//         _initialized = true;
//       });
//     } catch(e) {
//       // Set `_error` state to true if Firebase initialization fails
//       setState(() {
//         _error = true;
//       });
//     }
//   }

//   @override
//   void initState() {
//     initializeFlutterFire();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Show error message if initialization failed
//     // if(_error) {
//     //   return null;
//     // }

//     // // Show a loader until FlutterFire is initialized
//     // if (!_initialized) {
//     //   return null;
//     // }

//     return StreamProvider<MUser>.value (
//         value:  AuthenticationService().user,
//         child: MaterialApp(
//         home: Wrapper(),
//       ),
//     );
//   }
// }