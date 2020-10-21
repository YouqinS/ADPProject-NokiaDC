import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/models/user.dart';


class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  //collection reference
  final CollectionReference inventoryCollection = FirebaseFirestore.instance.collection("raspberries");

  Future updateUserData (String modelNumber, String name, String roles, int availability) async {
    return await inventoryCollection.doc(uid).set({
      'modelNumber': modelNumber,
      'name': name,
      'roles': roles,
      // 'location': location,
      'availability': availability,
    });
  }

  //lists of rasp from snpshots
  List<Rasp> _raspListFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Rasp(
        modelNumber: doc.data()['modelNumber'] ?? '',
        name: doc.data()['name'] ?? '',
        roles: doc.data()['roles'] ?? '',
        // location: doc.data()['location'] ?? 0.0,
        availability: doc.data()['availability'] ?? 0,
      );
    }).toList();
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      modelNumber: snapshot.data()['modelNumber'],
      name: snapshot.data()['name'],
      roles: snapshot.data()['roles'],
      availability: snapshot.data()['availability'],
      // location: snapshot.data()['location'],
    );
  }

  // get data streams
  Stream<List<Rasp>> get rasps {
    return inventoryCollection.snapshots()
        .map(_raspListFromSnapshots);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return inventoryCollection.doc(uid).snapshots()
      .map(_userDataFromSnapshot);
  }

}