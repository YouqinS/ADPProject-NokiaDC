import 'package:RasPiFinder/add_pi/add_pi.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/map/map_view.dart';
import 'package:RasPiFinder/pi_data/dataContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PiData extends StatefulWidget {
  final bool showFAB;
  PiData({Key key, this.showFAB}) : super(key: key);

  @override
  _PiDataState createState() => _PiDataState(showFAB);
}

class _PiDataState extends State<PiData> {
  //TODO type to be changed when db data model is ready
  String piUid, owner, user, finder, software, address, gps, other;

  final bool showFAB;
  _PiDataState(this.showFAB);

  @override
  Widget build(BuildContext context) {
    getPiData();
    Size size = MediaQuery.of(context).size;

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
            visible: showFAB,
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
                      content: piUid,
                      maxLine: 2,
                      isUser: false,
                    ),
                    divider,
                    DataContainer(
                      label: 'Software',
                      content: software,
                      maxLine: 2,
                      isUser: false,
                    ),
                    divider,
                    DataContainer(
                      label: 'Owner',
                      content: owner,
                      maxLine: 1,
                      isUser: true,
                    ),
                    divider,
                    DataContainer(
                      label: 'User',
                      content: user,
                      maxLine: 1,
                      isUser: true,
                    ),
                    divider,
                    DataContainer(
                      label: 'Finder',
                      content: finder,
                      maxLine: 1,
                      isUser: true,
                    ),
                    divider,
                    DataContainer(
                      label: 'Address',
                      content: address,
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
                    DataContainer(label: '', content: other, maxLine: 20, isUser: false,),
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
                visible: showFAB,
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
