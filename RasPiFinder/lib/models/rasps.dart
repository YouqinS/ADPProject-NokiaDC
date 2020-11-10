import 'package:cloud_firestore/cloud_firestore.dart';

class Rasp {
  final String modelNumber; //uid
  final String address;
  final String software;
  final String finderID;
  final String userID;
  final String ownerID;
  final String other;
  final GeoPoint geoPoint;

  Rasp({this.modelNumber, this.address, this.software, this.finderID,
      this.userID, this.ownerID, this.other, this.geoPoint});
}