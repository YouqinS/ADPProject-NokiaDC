import 'package:RasPiFinder/auth/login/login_page.dart';
import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/navigate.dart';
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
    var textStyle = TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.blue);
    return Scaffold(
        appBar: piAppBar,
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
                  Icon(
                    Icons.person,
                    color: Colors.blue[900],
                    size: size.width * 0.2,
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
                  FloatingActionButton.extended(
                      onPressed: () {
                        //for temporary testing
                        navigateToPage(context, LoginPage());
                      },
                      label: Text("LOG OUT",
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.2,
                            fontSize: 18,
                          )
                      ),
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
