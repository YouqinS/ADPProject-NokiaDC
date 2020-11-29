import 'dart:async';

import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/loading.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/map/map_only.dart';
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
  bool loading = false;


   Future loadMap() async {
    if (currentPi == null || currentPi.geoPoint == null) {
        setState(() => loading = true);
    } else {
      setState(() {
          loading = false;
        });
     return MapOnly(lastKnownGeopoint: new LatLng(currentPi.geoPoint.latitude, currentPi.geoPoint.longitude),);
    }  
  }

  @override
  Widget build(BuildContext context) {

    var futureBuilder = new FutureBuilder(
      future: loadMap(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            // return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return Container(
                child:MapOnly(lastKnownGeopoint: new LatLng(currentPi.geoPoint.latitude, currentPi.geoPoint.longitude)),
                height: MediaQuery.of(context).size.height / 4.0,
            );
        } 
      },
    );
    Size size = MediaQuery.of(context).size;
    final String user = (null == currentPi || currentPi.user == null) ? none : currentPi.user['email'];
    final String owner = (null == currentPi || currentPi.owner == null) ? none : currentPi.owner['email'];
    final String finder = (null == currentPi || currentPi.finder == null) ? none : currentPi.finder['email'];
    var divider = Divider(
      color: Colors.red,
    );

    getPiByModelNumber(modelNumber);

    return loading ? Loading() : Scaffold(
      appBar: PiAppBar(title: 'Pi Data').build(context),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              futureBuilder,
              Container(
                // borderRadius: BorderRadius.circular(5.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                child:   Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(80), topRight: Radius.circular(90))),
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
    dropdownValue = getCurrentRole();
  }


  String piOwnerText = "Owner", piUserText = "User", piFinderText = "Finder", otherType = "Unregister";
  String dropdownValue = "User";

  String getCurrentRole(){
    final currentUser = auth.currentUser;
    String currentRole = "";
    if (currentPi.owner != null && currentPi.owner["uid"] == currentUser.uid) {
      currentRole = piOwnerText;
    } else if (currentPi.user != null && currentPi.user["uid"] == currentUser.uid) {
      currentRole = piUserText;
    } else if (currentPi.finder != null && currentPi.finder["uid"] == currentUser.uid) {
      currentRole = piFinderText;
    }
    setState(() {
      dropdownValue = currentRole;
    });
    return currentRole;
  }

  List<String> getDropdownValues() {
    List<String> values = [];
    String currentRole = getCurrentRole();
    print("currentRole=" + currentRole);
    print("piUserText=" + piUserText);
    values.add(currentRole);
    values.add(piOwnerText);
    values.add(piUserText);
    values.add(piFinderText);
    values.add(otherType);
    if (currentRole == piOwnerText) {
      values.remove(piOwnerText);
    } else if (currentRole == piUserText) {
      values.remove(piUserText);
    } else if (currentRole == piFinderText) {
      values.remove(piFinderText);
    }
    print("********");
    print(values);
    return values;
  }

  openAlertBox () {
    List<String> values = getDropdownValues();
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
                      items: values.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
                  RaisedButton(
                    onPressed: updateData,
                    textColor: Colors.white,
                    color: Colors.blue,
                    padding: const EdgeInsets.all(8.0),
                    child: const Text('SUBMIT', style: TextStyle(fontSize: 20)),
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

    if(dropdownValue.isNotEmpty) {
      Map appUser = new Map();
      appUser['username'] = username;
      appUser['email'] = userX.email;
      appUser['phoneNumber'] = phone;
      appUser['uid'] = userX.uid;

      Rasp dataToUpdate = currentPi;

      if(dropdownValue == piUserText) {
        dataToUpdate.user = appUser;
        dataToUpdate.finder = (currentPi.finder != null && currentPi.finder["uid"] == appUser["uid"]) ? null : currentPi.finder;
        dataToUpdate.owner = (currentPi.owner != null && currentPi.owner["uid"] == appUser["uid"]) ? null : currentPi.owner;
      } else if (dropdownValue == piOwnerText) {
        dataToUpdate.owner = appUser;
        dataToUpdate.finder = (currentPi.finder != null && currentPi.finder["uid"] == appUser["uid"]) ? null : currentPi.finder;
        dataToUpdate.user = (currentPi.user != null && currentPi.user["uid"] == appUser["uid"]) ? null : currentPi.user;
      } else if (dropdownValue == piFinderText) {
        dataToUpdate.finder = appUser;
        dataToUpdate.user = (currentPi.user != null && currentPi.user["uid"] == appUser["uid"]) ? null : currentPi.user;
        dataToUpdate.owner = (currentPi.owner != null && currentPi.owner["uid"] == appUser["uid"]) ? null : currentPi.owner;
      } else if (dropdownValue == otherType) {
        dataToUpdate.user = (currentPi.user != null && currentPi.user["uid"] == appUser["uid"]) ? null : currentPi.user;
        dataToUpdate.owner = (currentPi.owner != null && currentPi.owner["uid"] == appUser["uid"]) ? null : currentPi.owner;
        dataToUpdate.finder = (currentPi.finder != null && currentPi.finder["uid"] == appUser["uid"]) ? null : currentPi.finder;
      }

      final QuerySnapshot snapshot = await docRef.where('modelNumber', isEqualTo: mn).get();
      snapshot.docs.forEach((DocumentSnapshot doc) {
        docRef.doc(doc.id).update({
          "user": dataToUpdate.user,
          "owner": dataToUpdate.owner,
          "finder": dataToUpdate.finder,
          "geoPoint": (position == null) ? null : GeoPoint(position.latitude, position.longitude),
          "address": myController1.text,
          "software": myController2.text,
          "other": myController3.text,
        },
        ).then((value) => print('User data updated successfully'))
            .catchError((error) => print('Failed to update user data'));

        stayOrLeave();
        clearDropdownValue();
      });

      print('userType=' + dropdownValue);
    }
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