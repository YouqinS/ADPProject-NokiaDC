import 'package:RasPiFinder/user_info/user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataContainer extends StatelessWidget {
  final String label, content;
  final int maxLine;
  final bool isUser;
  final Map user;

  const DataContainer(
      {Key key, this.label, this.content, this.maxLine, this.isUser, this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool noUser = user == null;
    String titleText = noUser ? 'Alert' : 'User Info';
    Widget body = noUser ? Text('Not available') :
    UserInfo(username: user["username"] == null ? "n/a" : user["username"] ,
        email: user["email"] == null ? "n/a" : user["email"],
        phone: user["phoneNumber"] == null ? "n/a" : user["phoneNumber"]);

    var styleLabel = TextStyle(
      color: Colors.blue[800],
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
      fontSize: 20,
    );
    var styleContent = TextStyle(
      color: Colors.black54,
      fontSize: 18,
    );

    Future<void> showAlert() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titleText),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  body
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    var contentHolder = isUser
        ? FlatButton(
            onPressed: () {
              showAlert();
            },
      color: Colors.grey[100],
            child: Text(
              content,
              style: styleContent,
              maxLines: maxLine,
            ),
          )
        : Text(
            content,
            style: styleContent,
            maxLines: maxLine,
          );

    var verticalPadding = isUser ? 0.0 : size.height * 0.015;

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: size.width * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: Text(
              label,
              style: styleLabel,
            ),
          ),
          Flexible(child: contentHolder),
        ],
      ),
    );
  }

}
