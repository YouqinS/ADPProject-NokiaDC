import 'package:RasPiFinder/add_pi/add_pi.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/map/map_view.dart';
import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/pi_data/dataContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PiData extends StatefulWidget {
  final bool showUpdateBtn, showUnregisterBtn;
  final Rasp rasp;
  PiData({Key key, this.showUpdateBtn, this.showUnregisterBtn, this.rasp}) : super(key: key);

  @override
  _PiDataState createState() => _PiDataState(showUpdateBtn, showUnregisterBtn, rasp);
}

class _PiDataState extends State<PiData> {
  //TODO type to be changed when db data model is ready
  String piUid, owner, user, finder, software, address, gps, other;

  final bool showUpdateBtn, showUnregisterBtn;
  final Rasp rasp;
  _PiDataState(this.showUpdateBtn, this.showUnregisterBtn, this.rasp);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var divider = Divider(
      color: Colors.red,
    );


    var notAvailable = 'not available';
    var none = 'none';
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
                      content: rasp.ownerID.isEmpty ? none : rasp.ownerID,
                      maxLine: 1,
                      isUser: true,
                    ),
                    divider,
                    DataContainer(
                      label: 'User',
                      content: rasp.userID.isEmpty ? none : rasp.userID,
                      maxLine: 1,
                      isUser: true,
                    ),
                    divider,
                    DataContainer(
                      label: 'Finder',
                      content: rasp.finderID.isEmpty ? none : rasp.finderID,
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
                                navigateToPage(context, MapView());
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
                    navigateToPage(context, AddPi());
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

  //TODO GET data from DB, this is for UI testing only
  void getPiData() {
    piUid = '7e19fb4a-ff84-4966-a376';
    user = 'abcd efgh wpeoh';
    owner = 'abcd efgh wpeoh';
    finder = 'abcd efgh wpeoh';
    software = 'RasPiOs';
    address = 'Karakaari 7, 02610 Espoo';
    gps = '41 24.2028,  2 10.4418';
    other =
    '41 24.2028,  2 10.4418 7e19fb4a-ff84-4966-a376-b9434027f866 abcd efgh wpeo';
  }
}
