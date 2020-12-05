import 'dart:ui';

import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/pi_data/pi_data.dart';
import 'package:RasPiFinder/widgets/theme.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {

  final Rasp rasp;
  ProductTile({ this.rasp });

  @override
  Widget build(BuildContext context) {
    var available = (rasp.user == null || rasp.user.isEmpty);
    return Container(
        margin: new EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: GestureDetector(
          onDoubleTap: () => null,
          onTap: () async {
            // await new Future.delayed(new Duration(seconds: 4));
            navigateToPage(context, PiData(rasp: rasp, showUpdateBtn: false,));
          },
          child: Container(
            height: 130,
            margin: new EdgeInsets.only(left: 33.0),
            decoration: new BoxDecoration(
              color: Colors.white,//new Color(0xFF526BC2),//new Color(0xFF333366),
              shape: BoxShape.rectangle,
              borderRadius: new BorderRadius.circular(8.0),
              boxShadow: <BoxShadow>[
                new BoxShadow(  
                  // color: Colors.blue,
                  // blurRadius: 10.0,
                  // offset: new Offset(4.0, 4.0),
                ),
              ],
          ),
          child: Container(
              constraints: BoxConstraints(maxWidth: 200),
              child: new Stack(
                children: <Widget>[
                  ListTile(
                    title: Padding(
                      padding: EdgeInsets.fromLTRB(40.0, 5.0, 0.0, 0.0),
                      child: Text(
                        "Model: "+ rasp.modelNumber, 
                        overflow: TextOverflow.ellipsis, 
                        softWrap: false, 
                        maxLines: 2,
                        style: TextStyle(
                    color: AppTheme.text, fontSize: 18.0,), textAlign: TextAlign.left),
                    ),
                    isThreeLine: true,
                    subtitle: Padding(
                      padding: EdgeInsets.fromLTRB(40.0, 5.0, 0.0,0.0),
                      child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [ Container (
                              child: Row(
                                children: [Icon(Icons.app_settings_alt, size: 25, color: Colors.lightBlueAccent,),
                                  Padding(child: Text(  (rasp.software==null ? "software" : rasp.software), style: TextStyle(
                                    color: AppTheme.text, fontSize: 15.0), 
                                    textAlign: TextAlign.left,),
                                    padding: EdgeInsets.only(left: 10)),]
                              ),
                        ), Container(
                          child: Row(
                                children: [Icon(Icons.pin_drop_sharp, size: 25, color: Colors.lightGreenAccent,),
                                  Padding(child: Text( (rasp.address==null ? "Address" : rasp.address), style: TextStyle(
                                    color: AppTheme.text, fontSize: 15.0), 
                                    textAlign: TextAlign.left,),
                                    padding: EdgeInsets.only(left: 10)),]
                              ),
                        )]
                      ),
                    ),
                  ),
                  FractionalTranslation(
                    translation: Offset(-0.5, 0.2),
                    child: Align(
                      child:CircleAvatar(
                        radius: 40.0,
                        backgroundColor: available ? Colors.green :  Colors.red,
                        child: Text(available ? "free" : "in use", style: TextStyle(color: Colors.white),)
                      ),
                      alignment: FractionalOffset(0.5, 0.0),
                    ),
                  ),   
                ],
              )
          ), 
        ),
      ),
      
    );
  }
}