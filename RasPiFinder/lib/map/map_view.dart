import 'package:RasPiFinder/components/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PiAppBar(title: 'Map View').build(context),
      body: Container(
        alignment: AlignmentDirectional.center,
        child: Text('MAP VIEW CONTAINER'),
      ),
    );
  }
}
