import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/pi_data/dataContainer.dart';
import 'package:RasPiFinder/pi_data/pi_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/models/rasps.dart';

class MyRasPi extends StatefulWidget {
  final List<Rasp> myPies;
  final List<UserData> users;

  const MyRasPi({Key key, this.myPies, this.users}) : super(key: key);

  @override
  _MyRasPiState createState() => _MyRasPiState(this.myPies, this.users);
}

class _MyRasPiState extends State<MyRasPi> {
  final List<Rasp> myPies;
  final List<UserData> users;
  _MyRasPiState(this.myPies, this.users);

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
    return Scaffold(
      appBar: PiAppBar(title: 'My RasPies').build(context),
      body: ListView.builder(
        itemCount: myPies.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              navigateToPage(context, PiData(showUpdateBtn: true, showUnregisterBtn: true, rasp: myPies[index], users: users,));
            },
            child: Card(
              elevation: 0.01,
              color: Colors.blue[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: Colors.blue[900],
                    child: Text(
                      (index + 1).toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  DataContainer(
                    label: 'Model No.',
                    content: myPies[index].modelNumber,
                    maxLine: 2,
                    isUser: false,
                  ),
                  DataContainer(
                    label: 'Software',
                    content: myPies[index].software == null ? "NA" : myPies[index].software,
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
}
