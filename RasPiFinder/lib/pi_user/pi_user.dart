import 'package:RasPiFinder/auth/components/app_bar.dart';
import 'package:RasPiFinder/auth/components/navigate.dart';
import 'package:RasPiFinder/auth/components/rounded_button.dart';
import 'package:RasPiFinder/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PisUser extends StatefulWidget {
  PisUser({Key key}) : super(key: key);

  @override
  PiUserInfo createState() => new PiUserInfo();
}

class PiUserInfo extends State<PisUser> {
  final formKey = GlobalKey<FormState>();
  String name, phone, building, room;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var textStyle = TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue
                      );
    return new Scaffold(
        appBar: piAppBar,
        body: Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name :',
                      labelStyle: textStyle,
                    ),
                    onSaved: (input) => name = input,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number :',
                      labelStyle: textStyle,
                    ),
                    onSaved: (input) => phone = input,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Office Building :',
                        labelStyle: textStyle,
                    ),
                    onSaved: (input) => building = input,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Office room :',
                        labelStyle: textStyle,
                    ),
                    onSaved: (input) => room = input,
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    width: size.width * 0.5,
                    child: RoundedButton(
                        text: 'Save',
                        press: () {
                          submit();
                          navigateToPage(context, HomePage());
                        },
                      )
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void submit(){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      //TODO get current GPS data and store to DB
      //TODO connect to DB to store user input
      print(name);
      print(phone);
      print(room);
      print(building);
    }
  }
}
