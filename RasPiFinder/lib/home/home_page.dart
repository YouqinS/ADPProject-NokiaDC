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
import 'package:qrscan/qrscan.dart' as scanner;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  //default value for testing: Nokia Espoo campus
  //GeoPoint geoPoint = new GeoPoint(60.22479775, 24.756725373913383);
  GeoPoint geoPoint;
  String modelNumber = '';

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
            //scanPiQrCode()
           addPiOrPiData(rasPiList, userData)
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
    print('getCurrentLocation');
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  getGeoPoint() {
    print('getGeoPoint');
      getCurrentLocation().then((result) => {
        setState(() {
          geoPoint = new GeoPoint(result.latitude, result.longitude);
          print('latitude=' + geoPoint.latitude.toString() + ', longitude=' + geoPoint.longitude.toString());
        }),
      });
  }

  Future<String> scanPiQrCode() async {
    String cameraScanResult = await scanner.scan();
    print('cameraScanResult='+ cameraScanResult);
    setState(() {
      modelNumber = cameraScanResult;
    });
    return cameraScanResult;
  }

  addPiOrPiData(List<Rasp> piesInDb, UserData userData) {
    getGeoPoint();
    scanPiQrCode();
    bool foundInDb = false;
    if (modelNumber.isNotEmpty) {
      for (Rasp pi in piesInDb) {
        if (pi.modelNumber == modelNumber) {
          navigateToPage(
              context,
              PiData(
                rasp: pi,
                showUpdateBtn: true,
              ));
          foundInDb = true;
          break;
        }
      }
      if (!foundInDb) {
        navigateToPage(
            context,
            AddPi(
              geoPoint: geoPoint,
              modelNumber: modelNumber,
              scanner: userData,
            ));
      }
    } else {
      showAlert();
    }
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
                Text('Failed to get data from qr code. Try again!'),
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
