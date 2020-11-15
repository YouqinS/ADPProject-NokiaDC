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

  String getValuesString() {
    var result = this.address + this.software;
    if (this.finder != null) {
      result += this.finder['email'] +
          this.finder['username'] +
          this.finder['phoneNumber'];
    }
    if (this.user != null) {
      result +=
          this.user['email'] + this.user['username'] + this.user['phoneNumber'];
    }
    if (this.owner != null) {
      result += this.owner['email'] +
          this.owner['username'] +
          this.owner['phoneNumber'];
    }
    return result.toLowerCase();
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
