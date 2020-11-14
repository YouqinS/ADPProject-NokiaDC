import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/map/map_view.dart';
import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/pi_data/dataContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:latlong/latlong.dart";

class PiData extends StatefulWidget {
  final bool showUpdateBtn, showUnregisterBtn;
  final Rasp rasp;
  //TODO should be removed, instead data model needs to have User object,
  final List<UserData> users; //temporarily used to get pi user/owner/finder info
  PiData({Key key, this.showUpdateBtn, this.showUnregisterBtn, this.rasp, this.users}) : super(key: key);

  @override
  _PiDataState createState() => _PiDataState(showUpdateBtn, showUnregisterBtn, rasp, users);
}

class _PiDataState extends State<PiData> {
  final String piOwner = "owner", piUser = "user", piFinder = "finder";
  var notAvailable = 'not available';
  var none = 'none';
  final bool showUpdateBtn, showUnregisterBtn;
  final Rasp rasp;
  final List<UserData> users;
  _PiDataState(this.showUpdateBtn, this.showUnregisterBtn, this.rasp, this.users);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final names = getNames(users, rasp);
    final String user = names[piUser] == null ? none : names[piUser];
    final String owner = names[piOwner] == null ? none : names[piOwner];
    final String finder = names[piFinder] == null ? none : names[piFinder];

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
        actions: <Widget>[
          Visibility(
            visible: showUnregisterBtn,
            child: FloatingActionButton.extended(
              //TODO remove user from this pi in db
              onPressed: null,
              label: Text('Unregister'),
              tooltip: 'Unregister from this Pi',
              backgroundColor: Colors.red[400],
              elevation: 0,
              heroTag: null,
            ),
          ),
        ],
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
                      content: rasp.ownerID.isEmpty ? none : owner,
                      maxLine: 1,
                      isUser: true,
                    ),
                    divider,
                    DataContainer(
                      label: 'User',
                      content: rasp.userID.isEmpty ? none : user,
                      maxLine: 1,
                      isUser: true,
                    ),
                    divider,
                    DataContainer(
                      label: 'Finder',
                      content: rasp.finderID.isEmpty ? none : finder,
                      maxLine: 1,
                      isUser: true,
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
                  onPressed: () {
                   //TODO implement update functionality
                  },
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

  void navToMap(BuildContext context) {
    if (rasp.geoPoint == null) {
      showAlert();
    } else {
      navigateToPage(context, MapView(lastKnownGeopoint: new LatLng(rasp.geoPoint.latitude, rasp.geoPoint.longitude),));
    }
  }

   getNames(List<UserData> users, Rasp pi) {
     final names = new Map();
    for (UserData userdata in users) {
      var username = (userdata.username == null || userdata.username.isEmpty) ? "not provided" : userdata.username;
      // print('userdata.uid=' + userdata.uid);
      // print('pi.userID=' + pi.userID);

      if (pi.userID == userdata.uid.replaceAll(" ", "")) {
        names[piUser] = username;
      }
      if (pi.ownerID == userdata.uid.replaceAll(" ", "")) {
        names[piOwner] = username;
      }

      if (pi.finderID == userdata.uid.replaceAll(" ", "")) {
        names[piFinder] = username;
      }
    }
    return names;
   }

  Future<void> showAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
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
        );
      },
    );
  }
}
