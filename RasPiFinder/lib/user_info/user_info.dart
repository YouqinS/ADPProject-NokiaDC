import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  final String username, email, phone;

  const UserInfo({Key key, this.username, this.email, this.phone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.person, color: Colors.blue[900],),
            Text(
              username,
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 22,
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.email, color: Colors.blue[900],),
            Text(
              //TODO get user info from db and display on this screen
              email,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18,
              ),
            ),
          ],
        ),

        SizedBox(
          height: size.height * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.phone_android, color: Colors.blue[900],),
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
    );
  }
}
