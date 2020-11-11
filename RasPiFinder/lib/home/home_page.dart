import 'package:RasPiFinder/add_pi/add_pi.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/models/rasps.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/services/database.dart';
import 'package:provider/provider.dart';
import 'rasp_list.dart';
import 'package:geolocator/geolocator.dart';
import "package:latlong/latlong.dart";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  GeoPoint geoPoint;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    /*void _showAddPanel() {
      showModalBottomSheet(
        context: context, 
        isScrollControlled: true, 
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        builder: (context) {
          return Container(
            // padding: MediaQuery.of(context).viewInsets,
            height: 500,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
            child: AddProducts(),
          );
        }
      );
    }*/

    return StreamProvider<List<Rasp>>.value(
          value: DatabaseService().rasps,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
              "RasPiFinder",
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              backgroundColor: Colors.blue,
              centerTitle: true,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.add), 
                  label: Text(''),
                  onPressed: () => {
                    //TODO
                    navigateToPage(context, AddPi())
                  }//_showAddPanel(),
                )
              ],
            ),
            body: RaspList(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  //get geopoint, can be called when camera starts, the new geo info can be stored to db together with other pi info
  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  getGps() {
    getCurrentLocation().then((result) => {
          setState(() {
            geoPoint = new GeoPoint(result.latitude, result.longitude);
          }),
        });
  }
}
