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

  String _getUserString(Map user) {
    var result = '';
    if (user != null) {
      if (user['email'] != null) {
        result += user['email'];
      }
      if (user['username'] != null) {
        result += user['username'];
      }
      if (user['phoneNumber'] != null) {
        result += user['phoneNumber'];
      }
    }
    return result;
  }

  String getValuesString() {
    return (this.address +
            this.software +
            this.modelNumber +
            _getUserString(this.finder) +
            _getUserString(this.user) +
            _getUserString(this.owner))
        .toLowerCase();
  }

  Rasp(
      {this.modelNumber,
      this.address,
      this.software,
      this.finder,
      this.user,
      this.owner,
      this.other,
      this.geoPoint});
}
