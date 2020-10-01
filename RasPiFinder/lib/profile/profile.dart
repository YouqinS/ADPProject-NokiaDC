import 'package:RasPiFinder/auth/components/navigate.dart';
import 'package:RasPiFinder/auth/components/navigation_bar.dart';
import 'package:RasPiFinder/auth/components/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  ProfileForm createState() => new ProfileForm();
}

class ProfileForm extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var textStyle = TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w400,
        color: Colors.blue
    );
    return Scaffold(
      backgroundColor: Colors.white,
        body: Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: size.width * 0.5,
                      alignment: Alignment.topRight,
                      child: FloatingActionButton.extended(
                        label: Text("avatar"),
                        backgroundColor: Colors.grey,
                        onPressed: () {  },
                      )
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'new username :',
                      labelStyle: textStyle,
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'new email :',
                      labelStyle: textStyle,
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'new password :',
                      labelStyle: textStyle,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                      width: size.width * 0.5,
                      child: RoundedButton(
                        text: 'Save',
                        press: () {
                          submit();
                          navigateToPage(context, NavPage());
                        },
                      )
                  )
                ],
              ),
            ),
          ),
        )
    );
  }

  void submit(){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      //TODO get current GPS data and store to DB
      //TODO connect to DB to store user input
    }
  }
}
