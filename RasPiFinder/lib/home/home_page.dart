import 'package:RasPiFinder/add_pi/add_pi.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/home/product_tile.dart';
import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/models/user.dart';
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
  GeoPoint geoPoint = new GeoPoint(60.22479775, 24.756725373913383);

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
                  icon: Icon(Icons.add), 
                  label: Text(''),
                  onPressed: () => {
                    //TODO query db and add navigation logic to AddPi or PiData(to update Pi)
                    navigateToPage(context, AddPi(geoPoint: geoPoint, scanner: userData,))
                  }//_showAddPanel(),
                )
              ],
            ),
            body: ListView.builder(
              itemCount: rasPiList.length,
              itemBuilder: (context, index) {
                return ProductTile(rasp: rasPiList[index]);
              },
            )
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
}
