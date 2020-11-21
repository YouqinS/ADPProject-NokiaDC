import 'package:RasPiFinder/add_pi/add_pi.dart';
import 'package:RasPiFinder/auth/Validator.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/home/rasp_list.dart';
import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/pi_data/pi_data.dart';
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
  ValueNotifier<bool> showSearchNotifier = ValueNotifier(false);

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
              fontSize: 20),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              label: Text(''),
              onPressed: () {
                showSearchNotifier.value = !showSearchNotifier.value;
              })
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: showSearchNotifier,
          builder: (context, value, child) {
            return RaspList(
              showSearch: value,
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => {
                getModelNumberAndNavigate(rasPiList, userData)
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
            print('latitude=' +
                geoPoint.latitude.toString() +
                ', longitude=' +
                geoPoint.longitude.toString());
          }),
        });
  }

  Future<String> scanPiQrCode() async {
    print("scanning...");
    String cameraScanResult = await scanner.scan();
    print('cameraScanResult=' + cameraScanResult);
    return cameraScanResult;
  }

  void getModelNumberAndNavigate(List<Rasp> piesInDb, UserData userData) {
    getGeoPoint();

    scanPiQrCode().then((value) => {
     setState(() {
       modelNumber = value;
       print('modelNumber=' + modelNumber);
     }),

      addPiOrPiData(piesInDb, userData)
    });
  }

  addPiOrPiData(List<Rasp> piesInDb, UserData userData) {
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
      Validator.showAlert(context, "Title", "Failed to get data. Try again!", 'OK');
    }
  }
}
