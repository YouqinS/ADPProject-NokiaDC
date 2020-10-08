import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/pi_data/dataContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PiData extends StatefulWidget {
  @override
  _PiDataState createState() => _PiDataState();
}

class _PiDataState extends State<PiData> {
  //TODO type to be changed when db data model is ready
  String piUid, owner, user, finder, software, address, gps, other;

  @override
  Widget build(BuildContext context) {
    getPiData();
    Size size = MediaQuery.of(context).size;

    var divider = Divider(
      color: Colors.red,
    );


    return Scaffold(
      appBar: PiAppBar(title: 'Pi Data').build(context),
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
                      label: 'Uid',
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
                      label: 'Location',
                      content: address,
                      maxLine: 3,
                      isUser: false,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FloatingActionButton.extended(
                          onPressed: (){
                            navigateToPage(context, PiData());
                          },
                          label: Text("Map"),
                          icon:Icon(Icons.map),
                        ),
                      ],
                    ),
                    divider,
                    DataContainer(label: 'Other', content: '', maxLine: 1, isUser: false,),
                    DataContainer(label: '', content: other, maxLine: 20, isUser: false,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //TODO GET data from DB, this is for UI testing only
  void getPiData() {
    piUid = '7e19fb4a-ff84-4966-a376-b9434027f866';
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
