import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/models/user.dart';


class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  //collection reference
  final CollectionReference inventoryCollection = FirebaseFirestore.instance.collection("pi");
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

/*
  Future addPi (String modelNumber, String name, String roles, int availability) async {
    return await inventoryCollection.doc(uid).set({
      'modelNumber': modelNumber,
      'name': name,
      'roles': roles,
      // 'location': location,
      'availability': availability,
    });
  }
*/

  Future createUser (String username, String email, String phoneNumber) async {
    return await userCollection.doc(uid).set({
      'phoneNumber': phoneNumber,
      'username': username,
      'email': email,
    });
  }

  //lists of rasp from snpshots
  List<Rasp> _raspListFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Rasp(
        modelNumber: doc.data()['modelNumber'] ?? '',
        address: doc.data()['address'] ?? '',
        software: doc.data()['software'] ?? '',
        finderID: doc.data()['finderID'] ?? '',
        userID: doc.data()['userID'] ?? '',
        ownerID: doc.data()['ownerID'] ?? '',
        other: doc.data()['other'] ?? '',
       geoPoint: doc.data()['geoPoint'] ?? null,
      );
    }).toList();
  }
  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    print('_userDataFromSnapshot UID=' + uid);
    print('snapshot data=');
    print(   snapshot.data());
    return UserData(
      uid: uid,
      phoneNumber: snapshot.data()['phoneNumber'] ?? "",
      username: snapshot.data()['username'] ?? "",
      email: snapshot.data()['email'] ?? "",
    );
  }

  List<UserData> _userListFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserData(
        uid: uid,
        phoneNumber: doc.data()['phoneNumber'],
        username: doc.data()['username'],
        email: doc.data()['email'],
      );
    }).toList();
  }

  // get data streams
  Stream<List<Rasp>> get rasps {
    return inventoryCollection.snapshots()
        .map(_raspListFromSnapshots);
  }

  //get user doc stream
  Stream<UserData> get userData {
    print('getUserData() userUID='+uid);
    return userCollection.doc(uid).snapshots()
      .map(_userDataFromSnapshot);
  }

  Stream<List<UserData>> get users {
    return userCollection.snapshots()
        .map(_userListFromSnapshots);
  }
}