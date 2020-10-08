import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/screens/wrapper.dart';
import 'package:RasPiFinder/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(RasPiFinder());
}

class RasPiFinder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MUser>.value (
        value:  AuthenticationService().user,
        child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
