import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/models/rasps.dart';

class ProductProvider with ChangeNotifier {
  final fireStoreService = FirebaseFirestore.instance;
  String modelNumber;
  String address;
  String software;
  String other;
  Map owner;
  Map user;
  Map finder;
  GeoPoint geoPoint;


  //Getters
  // String get _modelNumber => modelNumber;
  // String get _address => address;
  // String get _software => software;
  // String get _other => other;
  // String get _ownerID =>  ownerID;
  // String get _userID => userID;
  // String get  _finderID => finderID;
  // GeoPoint get _geoPoint =>  geoPoint;

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
    user = pi.user;
    finder = pi.finder;
    owner = pi.owner;
    other = pi.other;
  }
}