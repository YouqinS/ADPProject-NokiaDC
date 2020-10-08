import 'package:RasPiFinder/screens/profile/add_products.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/services/authentication_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {

  final AuthenticationService _authenticationService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    void _showAddPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: AddProducts(),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        centerTitle: true,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person), 
              label: Text("Logout"),
              onPressed: () async {
                await _authenticationService.signOut();
              }, 
            ),
            FlatButton.icon( 
              icon: Icon(Icons.add), 
              label: Text(''),
              onPressed: () => _showAddPanel(),
            ),
          ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}