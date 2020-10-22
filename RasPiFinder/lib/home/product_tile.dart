import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/pi_data/pi_data.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {

  final Rasp rasp;
  ProductTile({ this.rasp });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () {
          navigateToPage(context, PiData(showFAB: false,));
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.green[rasp.availability],
            ),
            title: Text(rasp.roles +' '+ '(' + rasp.name + ')'),
            subtitle: Text('The model number is ${rasp.modelNumber}'),
          ),
        ),
      ),
      
    );
  }
}