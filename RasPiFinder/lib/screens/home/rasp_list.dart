import 'package:RasPiFinder/models/rasps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:RasPiFinder/screens/home/product_tile.dart';

class RaspList extends StatefulWidget {
  @override
  _RaspListState createState() => _RaspListState();
}

class _RaspListState extends State<RaspList> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {

    final products = Provider.of<List<Rasp>>(context) ?? [];
      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductTile(rasp: products[index]);
      },      
    );
  }
}