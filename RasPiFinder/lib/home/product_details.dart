import 'package:RasPiFinder/models/rasps.dart';
import 'package:flutter/material.dart';


class ProductDetails extends StatefulWidget {
  ProductDetails(Rasp product);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product details"),
      ), 
    );
  }
}