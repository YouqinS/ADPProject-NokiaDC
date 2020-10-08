import 'package:RasPiFinder/auth/login/login_page.dart';
import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/components/rounded_button.dart';
import 'package:RasPiFinder/profile/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'my_pi.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  ProfileState createState() => new ProfileState();
}

class ProfileState extends State<Profile> {
  final formKey = GlobalKey<FormState>();

  //TODO get user info from db and display on this screen
  String username, email, phone;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setUserInfo();
    return Scaffold(
        appBar: PiAppBar(title: 'Profile').build(context),
        body: Card(
          color: Colors.grey[100],
          semanticContainer: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //TODO: can be changed to avatar if necessary
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.blue[100],
                    child: Icon(
                      Icons.person,
                      color: Colors.blue[900],
                      size: size.height * 0.1,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.006,
                      ),
                      Text(
                        //TODO get user info from db and display on this screen
                        email,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.006,
                      ),
                      Text(
                        //TODO get user info from db and display on this screen
                        phone,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ButtonTheme(
                    minWidth: size.width,
                    child: RaisedButton.icon(
                      color: Colors.grey[200],
                      onPressed: () {
                        //for temporary testing
                        navigateToPage(context, MyRasPi());
                      },
                      icon: Icon(
                        Icons.pie_chart_outline_outlined,
                        color: Colors.blue[900],
                      ),
                      label: Text("My RasPi(s)",
                          style: TextStyle(
                            color: Colors.blue,
                            letterSpacing: 1.2,
                            fontSize: 18,
                          )
                      ),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: size.width,
                    child: RaisedButton.icon(
                      color: Colors.grey[200],
                      onPressed: () {
                        //for temporary testing
                        navigateToPage(context, Settings());
                      },
                      icon: Icon(
                        Icons.settings,
                        color: Colors.blue[900],
                      ),
                      label: Text("Settings",
                          style: TextStyle(
                            color: Colors.blue,
                            letterSpacing: 1.2,
                            fontSize: 18,
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  RoundedButton(
                    text: "LOG OUT",
                    //TODO connect to DB to store user credentials and status
                    press: () {
                      navigateToPage(context, LoginPage());
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  //for UI testing only
  void setUserInfo() {
    username = 'RPiUser007';
    email = 'abc@ced.com';
    phone = '040 1234 567';
  }
}
