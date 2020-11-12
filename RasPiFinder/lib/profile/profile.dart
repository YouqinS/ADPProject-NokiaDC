import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/services/authentication_service.dart';
import 'package:RasPiFinder/profile/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'my_pi.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  ProfileState createState() => new ProfileState();
}

class ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  final formKey = GlobalKey<FormState>();
  final String notAvail = 'not available';

  final AuthenticationService _authenticationService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    final UserData userData = Provider.of<UserData>(context);

    final List<Rasp> piCollectionFromDB = Provider.of<List<Rasp>>(context) ?? [];

    List<Rasp> myPies = getMyPiList(userData.uid, piCollectionFromDB);
    final users = Provider.of<List<UserData>>(context) ?? [];
    print('Profile users=' + users.toString());
    return Scaffold(
        appBar: PiAppBar(title: 'Profile').build(context),
        body: Card(
          color: Colors.grey[100],
          semanticContainer: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //TODO: can be changed to avatar if necessary
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.blue[100],
                    child: Icon(
                      Icons.person,
                      color: Colors.blue[900],
                      size: size.height * 0.1,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          userData.username.isEmpty ? notAvail : userData.username,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontSize: 22,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                        SizedBox(
                          height: size.height * 0.006,
                        ),
                        Text(
                          userData.email.isEmpty ? notAvail : userData.email,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                        SizedBox(
                          height: size.height * 0.006,
                        ),
                        Text(
                          userData.phoneNumber.isEmpty ? notAvail : userData.phoneNumber,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ButtonTheme(
                    minWidth: size.width,
                    child: RaisedButton.icon(
                      color: Colors.grey[200],
                      onPressed: () {
                        navigateToPage(context, MyRasPi(myPies: myPies, users: users,));
                      },
                      icon: Icon(
                        Icons.pie_chart_outline_outlined,
                        color: Colors.blue[900],
                      ),
                      label: Text("My RasPi(s)",
                          style: TextStyle(
                            color: Colors.blue,
                            letterSpacing: 1.2,
                            fontSize: 18,
                          )
                      ),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: size.width,
                    child: RaisedButton.icon(
                      color: Colors.grey[200],
                      onPressed: () {
                        navigateToPage(context, Settings());
                      },
                      icon: Icon(
                        Icons.settings,
                        color: Colors.blue[900],
                      ),
                      label: Text("Settings",
                          style: TextStyle(
                            color: Colors.blue,
                            letterSpacing: 1.2,
                            fontSize: 18,
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  FlatButton(
                    onPressed: () async {
                      await _authenticationService.signOut();
                    },
                    child: Text("LOG OUT"),
                    color: Colors.red[300],
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  List<Rasp> getMyPiList(String userUid, List<Rasp> piCollectionFromDB) {
    final List<Rasp> myPies = [];
    for (int i=0; i<piCollectionFromDB.length; i++) {
      if (piCollectionFromDB[i].userID ==  userUid ||
          piCollectionFromDB[i].finderID == userUid ||
          piCollectionFromDB[i].ownerID == userUid) {
        myPies.add(piCollectionFromDB[i]);
      }
    }
    return myPies;
  }

  @override
  bool get wantKeepAlive => true;
}
