import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/models/rasps.dart';

class ProductProvider with ChangeNotifier {
  final fireStoreService = FirebaseFirestore.instance;
  String modelNumber;
  String address;
  String software;
  String other;
  String ownerID;
  String userID;
  String finderID;
  GeoPoint geoPoint;


  //Getters
  String get _modelNumber => modelNumber;
  String get _address => address;
  String get _software => software;
  String get _other => other;
  String get _ownerID =>  ownerID;
  String get _userID => userID;
  String get  _finderID => finderID;
  GeoPoint get _geoPoint =>  geoPoint;

  //Setters
  changeName(String value) {
    //_name = value;
    notifyListeners();
  }

  changeModel(String value) {
    modelNumber = value;
    notifyListeners();
  }

  loadValues(Rasp pi) {
    modelNumber = pi.modelNumber;
    software = pi.software;
    address = pi.address;
    geoPoint = pi.geoPoint;
    userID = pi.userID;
    finderID = pi.finderID;
    ownerID = pi.ownerID;
    other = pi.other;
  }

  // saveProduct(){
  //   print(_roles);
  //   if (_productId == null) {
  //     var newProduct = Product(name: name, model: model, productId: uuid.v4());
  //     fireStoreService.saveProduct(newProduct);
  //   } else {
  //     //Update
  //     var updatedProduct = 
  //         Product(name: name, model: _model, productId: _productId);
  //       fireStoreService.saveProduct(updatedProduct);
  //   }  
  //   // print('$name, $model');
  // }

  // removeProduct(String productId) {
  //   fireStoreService.removeProduct(productId);
  // }
}