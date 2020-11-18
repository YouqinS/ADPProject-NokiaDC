import 'package:RasPiFinder/auth/Validator.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/map/map_view.dart';
import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/pi_data/dataContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:firebase_core/firebase_core.dart';


class PiData extends StatefulWidget {

  final Rasp rasp;
  final bool showUpdateBtn;
      PiData({Key key, this.rasp, this.showUpdateBtn}) : super(key: key);

  @override
  _PiDataState createState() => _PiDataState(rasp, showUpdateBtn);
}

class _PiDataState extends State<PiData> {

  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  final bool showUpdateBtn;
  final String piOwner = "owner", piUser = "user", piFinder = "finder";
  var notAvailable = 'not available';
  var none = 'none';
  final Rasp rasp;
  _PiDataState(this.rasp, this.showUpdateBtn);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final String user = rasp.user == null ? none : rasp.user['email'];
    final String owner = rasp.owner == null ? none : rasp.owner['email'];
    final String finder = rasp.finder == null ? none : rasp.finder['email'];

    var divider = Divider(
      color: Colors.red,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pi Data",
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: <Widget>[ ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 0,
                color: Colors.white,
                child: Column(
                  children: [
                    DataContainer(
                      label: 'Model No.',
                      content: rasp.modelNumber.isEmpty ? notAvailable : rasp.modelNumber,
                      maxLine: 2,
                      isUser: false,
                    ),
                    divider,
                    DataContainer(
                      label: 'Software',
                      content: rasp.software.isEmpty? notAvailable : rasp.software,
                      maxLine: 2,
                      isUser: false,
                    ),
                    divider,
                    DataContainer(
                      label: 'Owner',
                      content: owner,
                      maxLine: 1,
                      isUser: true,
                      user: rasp.owner,
                    ),
                    divider,
                    DataContainer(
                      label: 'User',
                      content:  user,
                      maxLine: 1,
                      isUser: true,
                      user: rasp.user,
                    ),
                    divider,
                    DataContainer(
                      label: 'Finder',
                      content: finder,
                      maxLine: 1,
                      isUser: true,
                      user: rasp.finder,
                    ),
                    divider,
                    DataContainer(
                      label: 'Address',
                      content: rasp.address.isEmpty ? notAvailable : rasp.address,
                      maxLine: 3,
                      isUser: false,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Tooltip(
                          message: 'GPS when last scanned',
                          child: RaisedButton.icon(
                              onPressed: () {
                                navToMap(context);
                              },
                              label: Text('GPS',
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  )),
                              icon: Icon(
                                Icons.map,
                                color: Colors.blue,
                              )),
                        ),
                      ],
                    ),
                    divider,
                    DataContainer(label: 'Other', content: '', maxLine: 1, isUser: false,),
                    DataContainer(label: '', content: rasp.other.isEmpty ? notAvailable : rasp.other, maxLine: 20, isUser: false,),
                  ],
                ),
              ),
              Visibility(
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.blue[800],
                  elevation: 0,
                  label: Text(
                    "UPDATE",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  onPressed: openAlertBox,
                   //TODO implement update functionality
                  tooltip: 'Update Pi data',
                ),
                visible: showUpdateBtn,
              ),
            ],
          ),
        ),
      ),
    );
  }

  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();
  final myController4 = TextEditingController();
  final myController5 = TextEditingController();

  @override
  void dispose() {
    myController1.dispose();
    myController2.dispose();
    myController3.dispose();
    myController4.dispose();
    myController5.dispose();
    // Clean up the controller when the widget is removed from the widget tree.
    super.dispose();
  }

  openAlertBox() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField AlertDemo'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: myController1,
                  decoration: InputDecoration(hintText:'Enter owner\'s email'),
                ),
                TextField(
                  controller: myController2,
                  decoration: InputDecoration(hintText:'Enter user\'s email'),
                ),
                TextField(
                  controller: myController3,
                  decoration: InputDecoration(hintText:'Enter finder\'s email'),
                ),
                TextField(
                  controller: myController4,
                  decoration: InputDecoration(hintText:'Enter address'),
                ),
                TextField(
                  controller: myController5,
                  decoration: InputDecoration(hintText:'Enter additional information'),
                ),
              ],
            ),
            actions: [
              RaisedButton(
                onPressed: updateData,
                textColor: Colors.white,
                color: Colors.blue,
                padding: const EdgeInsets.all(10.0),
                    child: const Text('Update', style: TextStyle(fontSize: 20)),
              )
            ],
          );
         }
         );
    }

    updateData(){
    FirebaseFirestore.instance.collection("pi").doc("6ncNePezK7PebOabTC6U").update({
      "owner": myController1.text,
      "user" : myController2.text,
      "finder": myController3.text,
      "address": myController4.text,
      "other": myController5.text,
    },);
    }


  void navToMap(BuildContext context) {
    if (rasp.geoPoint == null) {
      Validator.showAlert(context, "Alert", "No GPS data available", "OK");
    } else {
      navigateToPage(context, MapView(lastKnownGeopoint: new LatLng(rasp.geoPoint.latitude, rasp.geoPoint.longitude),));
    }
  }
}
