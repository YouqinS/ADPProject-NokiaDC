import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/pi_data/dataContainer.dart';
import 'package:RasPiFinder/pi_data/pi_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyRasPi extends StatefulWidget {
  @override
  _MyRasPiState createState() => _MyRasPiState();
}

class _MyRasPiState extends State<MyRasPi> {
  String piUid, software;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getPiData();
    return Scaffold(
      appBar: PiAppBar(title: 'My RasPi(s)').build(context),
      body: ListView.builder(
        //TODO fetch data from db
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              print('card tapped');
              navigateToPage(context, PiData());
            },
            child: Card(
              elevation: 0.01,
              color: Colors.blue[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.blue[200],
                    child: Text(
                      (index + 1).toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),

                  DataContainer(
                    label: 'uid',
                    content: piUid,
                    maxLine: 2,
                    isUser: false,
                  ),
                  DataContainer(
                    label: 'Software',
                    content: software,
                    maxLine: 2,
                    isUser: false,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void getPiData() {
    piUid = '7e19fb4a-ff84-4966-a376-b9434027f866';
    software = 'RasPiOs';
  }
}
