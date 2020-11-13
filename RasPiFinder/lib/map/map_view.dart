import 'package:RasPiFinder/components/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import "package:latlong/latlong.dart";

class MapView extends StatefulWidget {
  final LatLng lastKnownGeopoint;

  const MapView({Key key, this.lastKnownGeopoint}) : super(key: key);
  @override
  _MapViewState createState() => _MapViewState(lastKnownGeopoint);
}

class _MapViewState extends State<MapView> {
  MapController controller = new MapController();
  final LatLng lastKnownGeopoint;

  _MapViewState(this.lastKnownGeopoint);

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  //for later user if necessary
  Future<void> getLastKnownPosition() async {
    await Geolocator.getLastKnownPosition();
  }

  buildMap() {
    print("latitude=" + lastKnownGeopoint.latitude.toString() + "longitude=" + lastKnownGeopoint.longitude.toString());
    controller.onReady.then((value) => {
      controller.move(new LatLng(lastKnownGeopoint.latitude, lastKnownGeopoint.longitude), 13.0),
    });
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PiAppBar(title: 'Map View').build(context),
      body: new FlutterMap(
        mapController: controller,
        options:
            new MapOptions(center: buildMap(), zoom: 13.0),
        layers: [
          new TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 80.0,
                height: 80.0,
                point:  lastKnownGeopoint,
                builder: (ctx) => new Container(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 50.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
