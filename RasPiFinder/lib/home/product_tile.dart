import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/pi_data/pi_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductTile extends StatelessWidget {

  final Rasp rasp;
  ProductTile({ this.rasp });

  @override
  Widget build(BuildContext context) {
    var available = (rasp.user == null || rasp.user.isEmpty);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () {
          navigateToPage(context, PiData(showUpdateBtn: false, showUnregisterBtn: false, rasp: rasp));
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: available ? Colors.green :  Colors.red,
              child: Text(available ? "free" : "in use", style: TextStyle(color: Colors.white),),
            ),
            title: Text("model: "+ rasp.modelNumber),
            subtitle: Text("sw: " + (rasp.software==null ? "software" : rasp.software)),
          ),
        ),
      ),
      
    );
  }
}