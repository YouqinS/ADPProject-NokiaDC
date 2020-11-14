//TODO can be removed
/*
import 'package:RasPiFinder/models/rasps.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/home/product_tile.dart';

class RaspList extends StatefulWidget {
  final List<Rasp> rasPiList;
  RaspList({this.rasPiList});

  @override
  _RaspListState createState() => _RaspListState(this.rasPiList);
}

class _RaspListState extends State<RaspList> {
  bool loading = false;
  final List<Rasp> rasPiList;
  _RaspListState(this.rasPiList);

  @override
  Widget build(BuildContext context) {
    print("rasPiList.length=" + rasPiList.length.toString());

      return ListView.builder(
        itemCount: rasPiList.length,
        itemBuilder: (context, index) {
          return ProductTile(rasp: rasPiList[index]);
      },
    );
  }
}*/
