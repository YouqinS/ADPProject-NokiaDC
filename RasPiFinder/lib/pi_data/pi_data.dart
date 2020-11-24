import 'dart:async';

import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/map/map_view.dart';
import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/pi_data/dataContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:RasPiFinder/auth/Validator.dart';
import 'package:geolocator/geolocator.dart';



class PiData extends StatefulWidget {

  final Rasp rasp;
  final bool showUpdateBtn;
  PiData({Key key, this.rasp, this.showUpdateBtn}) : super(key: key);

  @override
  _PiDataState createState() => _PiDataState(rasp, showUpdateBtn);
}

class _PiDataState extends State<PiData> {
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
                      user: rasp.owner,),
                    divider,
                    DataContainer(label: 'User',
                      content:  user,
                      maxLine: 1,
                      isUser: true,
                      user:rasp.user
                    ),
                    divider,
                    DataContainer(
                      label: 'Finder',
                      content: finder,
                      maxLine: 1,
                      isUser: true,
                      user:rasp.finder,
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

  @override
  void dispose() {
    myController1.dispose();
    myController2.dispose();
    myController3.dispose();
    // Clean up the controller when the widget is removed from the widget tree.
    super.dispose();
  }


  String select = 'Select a type', piOwnerText = "Owner", piUserText = "User", piFinderText = "Finder", otherType = "Other";
  Map<String, String> userA, ownerA, finderA;

  String dropdownValue = 'Select a type';
  openAlertBox () {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder:(context, setState){
              return AlertDialog(
                title: Text('Update Pi'),
                content: Column(mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                          validateUserTypeInput();
                        });},
                      items: <String>[select, piOwnerText, piUserText, piFinderText, otherType]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Expanded(
                      child: TextFormField(
                      controller: myController1,
                      decoration: InputDecoration(
                          labelText: 'Address',
                          hintText: 'Enter address'),
                    ),
                      flex: 1,
                    ),
                    Expanded(
                      child: TextFormField(
                      controller: myController2,
                      decoration: InputDecoration(
                          labelText: 'Software',
                          hintText: 'Enter software name'),
                    ),
                    flex: 1,),
                    Expanded(
                      child: TextFormField(
                      controller: myController3,
                      decoration: InputDecoration(
                          labelText: 'Other',
                          hintText: 'Enter additional information'),
                    ),
                    flex: 1,),
                  ],
                ),
                actions: [
                  Visibility(visible:dropdownValue!=select
                      ,child: RaisedButton(
                        onPressed: updateData,
                        textColor: Colors.white,
                        color: Colors.blue,
                        padding: const EdgeInsets.all(10.0),
                        child: const Text('Update', style: TextStyle(fontSize: 20)),
                  )
                  )
                ],
              );
            },
          );
        }
    );
  }


  CollectionReference docRef = FirebaseFirestore.instance.collection('pi');
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;


  void updateData()async{

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final userX = auth.currentUser;
    final String mn = rasp.modelNumber;


    final result = await userRef.doc(userX.uid).get();
    String username = result.data()['username'];
    String phone = result.data()['phoneNumber'];

    if (dropdownValue == select){
      validateUserTypeInput();
    }
    if(dropdownValue != select) {
      if (dropdownValue == piUserText) {
        userA = new Map();
        userA['username'] = username;
        userA['email'] = userX.email;
        userA['phoneNumber'] = phone;
        userA['uid'] = userX.uid;

        final QuerySnapshot snapshot = await docRef.where('modelNumber', isEqualTo: mn).get();
        snapshot.docs.forEach((DocumentSnapshot doc) {
          docRef.doc(doc.id).update({
            "user":userA,
            "owner": null,
            "finder": null
          },
          ).then((value) => print('User data updated successfully'))
              .catchError((error)=> print('Failed to update user data'));
        });

      }
      if (dropdownValue == piOwnerText) {
        ownerA = new Map();
        ownerA['username'] = username;
        ownerA['email'] = userX.email;
        ownerA['phoneNumber'] = phone;
        ownerA['uid'] = userX.uid;

        final QuerySnapshot snapshot = await docRef.where('modelNumber', isEqualTo: mn).get();
        snapshot.docs.forEach((DocumentSnapshot doc) {
          docRef.doc(doc.id).update({
            "user": null,
            "owner": ownerA,
            "finder": null
          },
          ).then((value) => print('User data updated successfully'))
              .catchError((error)=> print('Failed to update user data'));
        });

      }
      if (dropdownValue == piFinderText) {
        finderA = new Map();
        finderA['username'] = username;
        finderA['email'] = userX.email;
        finderA['phoneNumber'] = phone;
        finderA['uid'] = userX.uid;

        final QuerySnapshot snapshot = await docRef.where('modelNumber', isEqualTo: mn).get();
        snapshot.docs.forEach((DocumentSnapshot doc) {
          docRef.doc(doc.id).update({
            "user": null,
            "owner": null,
            "finder": finderA
          },
          ).then((value) => print('User data updated successfully'))
              .catchError((error)=> print('Failed to update user data'));
        });

      }
      if (dropdownValue == otherType) {
        final QuerySnapshot snapshot = await docRef.where('modelNumber', isEqualTo: mn).get();
        snapshot.docs.forEach((DocumentSnapshot doc) {
          docRef.doc(doc.id).update({
            "user": null,
            "owner": null,
            "finder": null
          },
          ).then((value) => print('User data updated successfully'))
              .catchError((error)=> print('Failed to update user data'));
        });
      }
      print('userType=' + dropdownValue);
    }


    final QuerySnapshot snapshot = await docRef.where('modelNumber', isEqualTo: mn).get();
    snapshot.docs.forEach((DocumentSnapshot doc) {
      docRef.doc(doc.id).update({
        "geoPoint": GeoPoint(position.latitude, position.longitude),
        "address": myController1.text,
        "software": myController2.text,
        "other": myController3.text,
      },
      ).then((value) => print('Pi data updated successfully'))
          .catchError((error)=> print('Failed to update pi data'));
    });
    Navigator.of(context).pop();
  }


  void navToMap(BuildContext context) {
    if (rasp.geoPoint == null) {
      showAlert();
    } else {
      navigateToPage(context, MapView(lastKnownGeopoint: new LatLng(rasp.geoPoint.latitude, rasp.geoPoint.longitude),));
    }
  }

  Future<void> showAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Alert'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('No Gps info available!'),
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
        ),);
      },
    );
  }


  void validateUserTypeInput() {
    if (dropdownValue == select) {
      Validator.showAlert(context, "Alert", "Please select a User Type", "OK");
    }
  }
}

