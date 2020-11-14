import 'package:cloud_firestore/cloud_firestore.dart';

class Rasp {
  final String modelNumber; //uid
  final String address;
  final String software;
  final Map finder;
  final Map user;
  final Map owner;
  final String other;
  final GeoPoint geoPoint;

  Rasp({this.modelNumber, this.address, this.software, this.finder,
      this.user, this.owner, this.other, this.geoPoint});
}