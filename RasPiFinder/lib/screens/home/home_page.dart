import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/screens/add_pi/add_pi.dart';
import 'package:RasPiFinder/screens/auth/Validator.dart';
import 'package:RasPiFinder/screens/components/backButtonPress.dart';
import 'package:RasPiFinder/screens/components/navigate.dart';
import 'package:RasPiFinder/screens/home/rasp_list.dart';
import 'package:RasPiFinder/screens/pi_data/pi_data.dart';
import 'package:RasPiFinder/widgets/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qrscans/qrscan.dart' as scanner;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  GeoPoint geoPoint;
  String modelNumber = '';
  ValueNotifier<bool> showSearchNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final UserData userData = Provider.of<UserData>(context);
    final rasPiList = Provider.of<List<Rasp>>(context) ?? [];
    return Stack(
      fit: StackFit.expand,
      children: [
        BackButtonPress(),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(4, 9, 35, 1),
                Color.fromRGBO(39, 105, 171, 1),
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              "RasPiFinder",
              style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                  colors: <Color>[
                    const Color(0xFF124191),
                    const Color(0xFF124191),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.0, 0.0),
                  stops: [0.0, 0.0],
                  tileMode: TileMode.clamp              
                ),
              ),
            ),
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
              backgroundColor: AppTheme.primary,
              onPressed: () => {
                    getModelNumberAndNavigate(rasPiList, userData)
                  },
              icon: Icon(
                Icons.camera_alt_rounded,
              ),
              label: Text("ScanQR"),
          ),
        ),
      ],
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
