import 'package:RasPiFinder/add_pi/add_pi.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/home/product_tile.dart';
import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/pi_data/pi_data.dart';
import 'package:RasPiFinder/search/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  //default value for testing: Nokia Espoo campus
  GeoPoint geoPoint = new GeoPoint(60.22479775, 24.756725373913383);
  String modelNumber = '123abc';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final UserData userData = Provider.of<UserData>(context);
    final rasPiList = Provider.of<List<Rasp>>(context) ?? [];
    return Scaffold(
            appBar: AppBar(
              title: Text(
              "RasPiFinder",
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
                FlatButton.icon(
                  icon: Icon(Icons.search, color: Colors.white,),
                  label: Text(''),
                  onPressed: () => {
                    navigateToPage(context, SearchPage())
                  }
                )
              ],
            ),
            body: ListView.builder(
              itemCount: rasPiList.length,
              itemBuilder: (context, index) {
                return ProductTile(rasp: rasPiList[index]);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => {
                //TODO scan pi to get model number
                addPiOrPiData(rasPiList, modelNumber, userData)
              },
          icon: Icon(
            Icons.camera_alt_rounded,
          ),
          label: Text('Scan QR')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  bool get wantKeepAlive => true;

  //get geopoint, can be called when camera starts, the new geo info can be stored to db together with other pi info
  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  getGps() {
    print('getCurrentLocation');
    getCurrentLocation().then((result) => {
          setState(() {
            geoPoint = new GeoPoint(result.latitude, result.longitude);
          }),
        });
    //print('latitude=' + geoPoint.latitude.toString() + ', longitude=' + geoPoint.longitude.toString());
  }

  addPiOrPiData(List<Rasp> piesInDb, String modelNumber, UserData userData){
    bool foundInDb = false;
    for(Rasp pi in piesInDb) {
      if (pi.modelNumber == modelNumber) {
        showOptions(pi, userData);
        foundInDb = true;
        break;
      }
    }
    if (!foundInDb) {
      navigateToPage(context, AddPi(geoPoint: geoPoint, modelNumber: modelNumber, scanner: userData,));
    }
  }

  showOptions(Rasp pi, UserData userData) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Found Pi in database, what would you like to do?'),
          actions: <Widget>[
            TextButton(
              child: Text('View Pi'),
              onPressed: () {
                Navigator.pop(context);
                navigateToPage(
                    context,
                    PiData(
                      rasp: pi,
                      showUpdateBtn: true,
                    ));
              },
            ),
            TextButton(
              child: Text('Update Pi'),
              onPressed: () {
                Navigator.pop(context);
                navigateToPage(
                    context,
                    AddPi(
                      geoPoint: geoPoint,
                      scanner: userData,
                    ));
              },
            ),
          ],
        );
      },
    );
  }
}
