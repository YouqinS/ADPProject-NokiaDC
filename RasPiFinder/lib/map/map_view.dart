import 'package:RasPiFinder/components/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong/latlong.dart";

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    var latLng = new LatLng(40.71, -74.00);
    return Scaffold(
      appBar: PiAppBar(title: 'Map View').build(context),
      body: new FlutterMap(
        options: new MapOptions(
          center: latLng,
          zoom: 13.0,
          minZoom: 10.0
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']
          ),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 80.0,
                height: 80.0,
                point: latLng,
                builder: (ctx) =>
                new Container(
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
