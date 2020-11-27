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
  _PiDataState createState() => _PiDataState(rasp.modelNumber, showUpdateBtn);
}

class _PiDataState extends State<PiData> {
  final bool showUpdateBtn;
  final String piOwner = "owner", piUser = "user", piFinder = "finder";
  var notAvailable = 'not available';
  var none = 'none';
  final String modelNumber;
  Rasp currentPi;
  _PiDataState(this.modelNumber, this.showUpdateBtn);



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final String user = (null == currentPi || currentPi.user == null) ? none : currentPi.user['email'];
    final String owner = (null == currentPi || currentPi.owner == null) ? none : currentPi.owner['email'];
    final String finder = (null == currentPi || currentPi.finder == null) ? none : currentPi.finder['email'];
    var divider = Divider(
      color: Colors.red,
    );

    getPiByModelNumber(modelNumber);


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
                      content: (null == currentPi || currentPi.modelNumber.isEmpty) ? notAvailable : currentPi.modelNumber,
                      maxLine: 2,
                      isUser: false,
                    ),
                    divider,
                    DataContainer(
                      label: 'Software',
                      content: (null == currentPi || currentPi.software.isEmpty) ? notAvailable : currentPi.software,
                      maxLine: 2,
                      isUser: false,
                    ),
                    divider,
                    DataContainer(
                      label: 'Owner',
                      content: owner,
                      maxLine: 1,
                      isUser: true,
                      user: null == currentPi ? null : currentPi.owner,),
                    divider,
                    DataContainer(label: 'User',
                        content:  user,
                        maxLine: 1,
                        isUser: true,
                        user:null == currentPi ? null : currentPi.user
                    ),
                    divider,
                    DataContainer(
                      label: 'Finder',
                      content: finder,
                      maxLine: 1,
                      isUser: true,
                      user:null == currentPi ? null : currentPi.finder,
                    ),
                    divider,
                    DataContainer(
                      label: 'Address',
                      content: (null == currentPi || currentPi.address == null || currentPi.address.isEmpty) ? notAvailable : currentPi.address,
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
                    DataContainer(label: '', content: (null == currentPi || currentPi.other == null || currentPi.other.isEmpty) ? notAvailable : currentPi.other, maxLine: 20, isUser: false,),
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
                visible: showUpdateBtn
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future getPiByModelNumber(String modelNumber) async {
    CollectionReference docRef = FirebaseFirestore.instance.collection('pi');
    final QuerySnapshot querySnapshot = await docRef.where('modelNumber', isEqualTo: modelNumber).get();

    var snapshot = querySnapshot.docs[0];

    setState((){
      currentPi = Rasp(
          modelNumber: snapshot.data()['modelNumber'] ?? "",
          address: snapshot.data()['address'] ?? "",
          software: snapshot.data()['software'] ?? "",
          other: snapshot.data()['other'] ?? "",
          owner: snapshot.data()['owner'] ?? null,
          user: snapshot.data()['user'] ?? null,
          finder: snapshot.data()['finder'] ?? null,
          geoPoint: snapshot.data()['geoPoint'] ?? null,
      );
    });
  }


  TextEditingController myController1 = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  TextEditingController myController3 = TextEditingController();



  @override
  void dispose(){
    myController1.dispose();
    myController2.dispose();
    myController3.dispose();
    // Clean up the controller when the widget is removed from the widget tree.
    super.dispose();
  }

  clearDropdownValue(){
    dropdownValue = select;
  }


  String select = 'Select a type', piOwnerText = "Owner", piUserText = "User", piFinderText = "Finder", otherType = "Unregister";
  Map<String, String> userA, ownerA, finderA;
  String dropdownValue = 'Select a type';

  openAlertBox () {
    myController1 = TextEditingController(text: (currentPi == null || currentPi.address.isEmpty) ? "":currentPi.address);
    myController2 = TextEditingController(text: (currentPi == null || currentPi.software.isEmpty) ? "":currentPi.software);
    myController3 = TextEditingController(text: (currentPi == null || currentPi.other.isEmpty) ? "":currentPi.other);

    showDialog(
        context: context,
        builder: (context){
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
                    Visibility(
                      child: Expanded(
                        child: TextFormField(
                          controller: myController1,
                          decoration: InputDecoration(
                            labelText: 'Address',
                              hintText: 'Enter address'
                           ),
                        ),
                        flex: 1),
                      visible: dropdownValue != otherType,
                    ),
                    Visibility(
                      child: Expanded(
                        child: TextFormField(
                          controller: myController2,
                          decoration: InputDecoration(
                            labelText: 'Software',
                              hintText: 'Enter software name'
                              ),
                        ),
                        flex: 1,),
                      visible: dropdownValue != otherType,
                    ),
                    Visibility(
                      child: Expanded(
                        child: TextFormField(
                        controller: myController3,
                        decoration: InputDecoration(
                          labelText: 'Additional Information',
                            hintText: 'Enter additional information'
                        ),
                        ),
                        flex: 1,),
                      visible: dropdownValue != otherType,
                    )
                  ],
                ),
                actions: [
                  Visibility(visible:dropdownValue!=select
                      ,child: RaisedButton(
                        onPressed: updateData,
                        textColor: Colors.white,
                        color: Colors.blue,
                        padding: const EdgeInsets.all(8.0),
                        child: const Text('SUBMIT', style: TextStyle(fontSize: 20)),
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


  void updateData()async {

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final userX = auth.currentUser;
    final String mn = modelNumber;


    final result = await userRef.doc(userX.uid).get();
    String username = result.data()['username'];
    String phone = result.data()['phoneNumber'];

    if(dropdownValue == select) {
      validateUserTypeInput();
    }

    if(dropdownValue != select) {

      if(dropdownValue == piUserText) {
        if(currentPi.finder['email'] == userX.email){
        userA = new Map();
        userA['username'] = username;
        userA['email'] = userX.email;
        userA['phoneNumber'] = phone;
        userA['uid'] = userX.uid;

        final QuerySnapshot snapshot = await docRef.where('modelNumber', isEqualTo: mn).get();
        snapshot.docs.forEach((DocumentSnapshot doc) {
          docRef.doc(doc.id).update({
            "user": userA,
            "finder": null
          },
          ).then((value) => print('User data updated successfully'))
              .catchError((error) => print('Failed to update user data'));
        });
      }

        else{
          userA = new Map();
          userA['username'] = username;
          userA['email'] = userX.email;
          userA['phoneNumber'] = phone;
          userA['uid'] = userX.uid;

          final QuerySnapshot snapshot = await docRef.where('modelNumber', isEqualTo: mn).get();
          snapshot.docs.forEach((DocumentSnapshot doc) {
            docRef.doc(doc.id).update({
              "user": userA,
              "owner": null,
            },
            ).then((value) => print('User data updated successfully'))
                .catchError((error) => print('Failed to update user data'));
          });
        }
      }

      if(dropdownValue == piOwnerText){
        if(currentPi.finder['email'] == userX.email){
          ownerA = new Map();
          ownerA['username'] = username;
          ownerA['email'] = userX.email;
          ownerA['phoneNumber'] = phone;
          ownerA['uid'] = userX.uid;

          final QuerySnapshot snapshot = await docRef.where('modelNumber', isEqualTo: mn).get();
          snapshot.docs.forEach((DocumentSnapshot doc) {
            docRef.doc(doc.id).update({
              "owner": ownerA,
              "finder": null
            },
            ).then((value) => print('User data updated successfully'))
                .catchError((error) => print('Failed to update user data'));
          });
        }

        else{
          ownerA = new Map();
          ownerA['username'] = username;
          ownerA['email'] = userX.email;
          ownerA['phoneNumber'] = phone;
          ownerA['uid'] = userX.uid;

          final QuerySnapshot snapshot = await docRef.where(
              'modelNumber', isEqualTo: mn).get();
          snapshot.docs.forEach((DocumentSnapshot doc){
            docRef.doc(doc.id).update({
              "owner": ownerA,
              "user": null
            },
            ).then((value) => print('User data updated successfully'))
                .catchError((error) => print('Failed to update user data'));
          });
        }
      }

      if(dropdownValue == piFinderText){
        if(currentPi.user['email'] == userX.email){
          finderA = new Map();
          finderA['username'] = username;
          finderA['email'] = userX.email;
          finderA['phoneNumber'] = phone;
          finderA['uid'] = userX.uid;

          final QuerySnapshot snapshot = await docRef.where('modelNumber', isEqualTo: mn).get();
          snapshot.docs.forEach((DocumentSnapshot doc) {
            docRef.doc(doc.id).update({
              "user": null,
              "finder": finderA
            },
            ).then((value) => print('User data updated successfully'))
                .catchError((error) => print('Failed to update user data'));
          });
        }

      else{
          finderA = new Map();
          finderA['username'] = username;
          finderA['email'] = userX.email;
          finderA['phoneNumber'] = phone;
          finderA['uid'] = userX.uid;

          final QuerySnapshot snapshot = await docRef.where('modelNumber', isEqualTo: mn).get();
          snapshot.docs.forEach((DocumentSnapshot doc) {
            docRef.doc(doc.id).update({
              "owner": null,
              "finder": finderA
            },
            ).then((value) => print('User data updated successfully'))
                .catchError((error) => print('Failed to update user data'));
          });
        }
      }

      if(dropdownValue == otherType){
        if(currentPi.finder['email'] == userX.email){
          final QuerySnapshot snapshot = await docRef.where(
              'modelNumber', isEqualTo: mn).get();
          snapshot.docs.forEach((DocumentSnapshot doc){
            docRef.doc(doc.id).update({
              "finder":null,
            },
            ).then((value) => print('User data is removed from this pi'))
                .catchError((error) => print('Failed to update user data'));
          });
        }

        else if(currentPi.user['email'] == userX.email){
          final QuerySnapshot snapshot = await docRef.where('modelNumber', isEqualTo: mn).get();
          snapshot.docs.forEach((DocumentSnapshot doc) {
            docRef.doc(doc.id).update({
              "user": null,
            },
            ).then((value) => print('User data is removed from this pi'))
                .catchError((error) => print('Failed to update user data'));
          });
        }

        else{
          final QuerySnapshot snapshot = await docRef.where('modelNumber', isEqualTo: mn).get();
          snapshot.docs.forEach((DocumentSnapshot doc) {
            docRef.doc(doc.id).update({
              "owner": null,
            },
            ).then((value) => print('User data is removed from this pi'))
                .catchError((error) => print('Failed to update user data'));
          });
        }
      }
      stayOrLeave();
      print('userType=' + dropdownValue);
    }


    final QuerySnapshot snapshot = await docRef.where(
        'modelNumber', isEqualTo: mn).get();
    snapshot.docs.forEach((DocumentSnapshot doc) {
      docRef.doc(doc.id).update({
        "geoPoint": GeoPoint(position.latitude, position.longitude),
        "address": myController1.text,
        "software": myController2.text,
        "other": myController3.text,
      },
      ).then((value) => print('Pi data updated successfully'))
          .catchError((error) => print('Failed to update pi data'));
      clearDropdownValue();
    });
  }

  void navToMap(BuildContext context) {
    if (currentPi.geoPoint == null) {
      showAlert();
    } else {
      navigateToPage(context, MapView(lastKnownGeopoint: new LatLng(currentPi.geoPoint.latitude, currentPi.geoPoint.longitude),));
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
          ),
        );
      },
    );
  }


  void validateUserTypeInput() {
    if (dropdownValue == select) {
      Validator.showAlert(context, "Alert", "Please select a User Type", "OK");
    }
    if (dropdownValue == otherType) {
      Validator.showAlert(context, "Alert", "Selecting Unregister will delete all your data from this pi!", "OK");
    }
  }

  void stayOrLeave(){
    if (dropdownValue == otherType) {
      Navigator.of(context).popUntil(ModalRoute.withName('/')); // back to MyRasPie page
//    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false); // back to homepage
    }
    else {
      Navigator.of(context).pop();
    }
  }
}