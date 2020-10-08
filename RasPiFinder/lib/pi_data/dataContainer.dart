import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataContainer extends StatelessWidget {
  final String label, content;
  final int maxLine;
  final bool isUser;

  const DataContainer(
      {Key key, this.label, this.content, this.maxLine, this.isUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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

    var contentHolder = isUser
        ? FlatButton(
      //TODO clicking leads to user info page or popup ?
            onPressed: () {},
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
