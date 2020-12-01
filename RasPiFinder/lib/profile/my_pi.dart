import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/loading.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/pi_data/dataContainer.dart';
import 'package:RasPiFinder/pi_data/pi_data.dart';
import 'package:RasPiFinder/widgets/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/models/rasps.dart';

class MyRasPi extends StatefulWidget {
  final String uid;
  const MyRasPi({Key key, this.uid}) : super(key: key);

  @override
  _MyRasPiState createState() => _MyRasPiState(uid);
}

class _MyRasPiState extends State<MyRasPi> {
  List<Rasp> myPies = [];
  final String uid;
  _MyRasPiState(this.uid);
  bool loading = false;
  GeoPoint geoPoint;
  Rasp currentPi;


  @override
  void dispose() {
    super.dispose();
  }

  Future loadMap() async {
    if (currentPi == null) {
        setState(() => loading = true);
    } else {
      setState(() {
          loading = false;
        });
      await new Future.delayed(new Duration(seconds: 4));
    }    
  }

  @override
  Widget build(BuildContext context) {
    getMyPies();
  
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(4, 9, 35, 1),
                Color.fromRGBO(39, 105, 171, 1),
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            ),
          ),
        ),
        loading ? Loading() :  new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PiAppBar(title: 'My RasPies').build(context),
          // body: futureBuilder,
          body: ListView.builder(
            itemCount: myPies.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () async {
                  if (currentPi != null && currentPi.geoPoint != null ) {
                        // setState(() => loading = true);
                        // await new Future.delayed(new Duration(seconds: 4));
                        navigateToPage(context, PiData(rasp: myPies[index], showUpdateBtn: true,));
                        // getMyPies();
                    } else {
                      setState(() {
                          loading = false;
                        });
                      // await new Future.delayed(new Duration(seconds: 4));
                      navigateToPage(context, PiData(rasp: myPies[index], showUpdateBtn: true,));
                    }
                },
                child: Card(
                  margin: new EdgeInsets.fromLTRB(20,15,20,10),
                  elevation: 0.40,
                  color: Colors.blue[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 11,
                        backgroundColor: AppTheme.primary,
                        child: Text(
                          (index + 1).toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      DataContainer(
                        label: 'Model No.',
                        content: myPies[index].modelNumber,
                        maxLine: 2,
                        isUser: false,
                      ),
                      DataContainer(
                        label: 'Software',
                        content: myPies[index].software == null ? "NA" : myPies[index].software,
                        maxLine: 2,
                        isUser: false,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  //TODO: add wrapper for security
  Future<List<QueryDocumentSnapshot>> getPiesByUserId() async {
    List<QueryDocumentSnapshot> snapshots = [];
    CollectionReference docRef = FirebaseFirestore.instance.collection('pi');
    QuerySnapshot querySnapshot = await docRef.where("owner.uid", isEqualTo: uid).get();
    List<QueryDocumentSnapshot> snapshot = querySnapshot.docs;
    snapshots.addAll(snapshot);

    querySnapshot = await docRef.where("user.uid", isEqualTo: uid).get();
    snapshot = querySnapshot.docs;
    snapshots.addAll(snapshot);

    querySnapshot = await docRef.where("finder.uid", isEqualTo: uid).get();
    snapshot = querySnapshot.docs;
    snapshots.addAll(snapshot);

    return snapshots;
  }

  getMyPies() {
    getPiesByUserId().then((snapshots) => {
    setState(() {
      myPies = snapshotsToPies(snapshots);
    })
    });
  }

  List<Rasp> snapshotsToPies(List<QueryDocumentSnapshot> snapshots) {
    List<Rasp> myPies = [];
    for (QueryDocumentSnapshot snapshot in snapshots) {
      Rasp pi = Rasp(
        modelNumber: snapshot.data()['modelNumber'] ?? "",
        address: snapshot.data()['address'] ?? "",
        software: snapshot.data()['software'] ?? "",
        other: snapshot.data()['other'] ?? "",
        owner: snapshot.data()['owner'] ?? null,
        user: snapshot.data()['user'] ?? null,
        finder: snapshot.data()['finder'] ?? null,
        geoPoint: snapshot.data()['geoPoint'] ?? null,
      );
      myPies.add(pi);
    }

    return myPies;
  }
}
