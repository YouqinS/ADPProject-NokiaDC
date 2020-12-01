import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/onboarding/sharedPreferences.dart';
import 'package:RasPiFinder/services/authentication_service.dart';
import 'package:RasPiFinder/profile/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Profile extends StatefulWidget {
  // final UserData userData;
  final String uid;
  Profile({Key key, this.uid}) : super(key: key);


  @override
  ProfileState createState() =>  ProfileState(uid);
}

class ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  final AuthenticationService _authenticationService = AuthenticationService();
  List<Rasp> myPies = [];
  final String uid;
  ProfileState(this.uid);

  // final UserData userData;
  // ProfileState(this.userData);

  final formKey = GlobalKey<FormState>();
  final String notAvail = 'not available';


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    getMyPies();
    super.build(context);
    UserData userData = Provider.of<UserData>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // Size size = MediaQuery.of(context).size;
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
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              "Profile",
              style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                  colors: <Color>[
                    const Color(0xFF124191),
                    const Color(0xFF124191),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.0, 0.0),
                  stops: [0.0, 0.0],
                  tileMode: TileMode.clamp              
                ),
              ),
            ),
            centerTitle: true,
            actions: <Widget>[
              FlatButton.icon(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  label: Text(''),
                  onPressed: () {
                    MSharedPreferences.instance.setBooleanValue("toSettings", true);
                    navigateToPage( context, SettingsPage(
                              userData: userData,
                            ));
                  })
            ],
          ),
          
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Container(
                    height: height * 0.43,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double innerHeight = constraints.maxHeight;
                        double innerWidth = constraints.maxWidth;
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: innerHeight * 0.72,
                                width: innerWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 80,
                                    ),
                                    Text(
                                      userData == null || userData.username.isEmpty
                                          ? notAvail
                                          : userData.username,
                                      style: TextStyle(
                                        color: Color.fromRGBO(39, 105, 171, 1),
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        fontSize: 37,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Total Rasps',
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontFamily: 'Nunito',
                                                fontSize: 25,
                                              ),
                                            ),
                                            Text(
                                              myPies.length.toString(),
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    39, 105, 171, 1),
                                                fontFamily: 'Nunito',
                                                fontSize: 25,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 25,
                                            vertical: 10,
                                          ),
                                          child: Container(
                                            height: 50,
                                            width: 3,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'My Rasps',
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontFamily: 'Nunito',
                                                fontSize: 25,
                                              ),
                                            ),
                                            Text(
                                              myPies.length.toString(),
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    39, 105, 171, 1),
                                                fontFamily: 'Nunito',
                                                fontSize: 25,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  height: 150,
                                  width: 200,
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage('assets/searching.jpg')
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: height * 0.55,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Details',
                            style: TextStyle(
                              color: Color.fromRGBO(39, 105, 171, 1),
                              fontSize: 27,
                              fontFamily: 'Nunito',
                            ),
                          ),
                          Divider(
                            thickness: 2.5,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: 
                              Text(
                                  'Username:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Nunito',
                                  )
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.05,
                            width: width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                            ),
                              child: Text(
                              userData == null || userData.username.isEmpty
                                  ? notAvail
                                  : userData.username,
                              style: TextStyle(
                                color: Color.fromRGBO(39, 105, 171, 1),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                fontSize: 22,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: 
                              Text(
                                  'Email:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Nunito',
                                  )
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.05,
                            width: width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Text(
                              userData == null || userData.email.isEmpty
                                  ? notAvail
                                  : userData.email,
                              style: TextStyle(
                                color: Color.fromRGBO(39, 105, 171, 1),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                fontSize: 22,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: 
                              Text(
                                  'Phone Number:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Nunito',
                                  )
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.05,
                            width: width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Text(
                              userData == null || userData.phoneNumber.isEmpty
                                  ? notAvail
                                  : userData.phoneNumber,
                              style: TextStyle(
                                color: Color.fromRGBO(39, 105, 171, 1),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                fontSize: 22,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RaisedButton(
                            onPressed: () async {
                              await _authenticationService.signOut();
                            },
                            child: Text("LOG OUT", style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Nunito'
                            ),),                              
                              // color: Colors.red[300],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

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

  @override
  bool get wantKeepAlive => true;
}
