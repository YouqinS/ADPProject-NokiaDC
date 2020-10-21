import 'package:RasPiFinder/models/rasps.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/services/database.dart';
import 'package:provider/provider.dart';
import 'add_products.dart';
import 'rasp_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
  with AutomaticKeepAliveClientMixin {  

  @override
  Widget build(BuildContext context) {
    super.build(context);

    void _showAddPanel() {
      showModalBottomSheet(
        context: context, 
        isScrollControlled: true, 
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        builder: (context) {
          return Container(
            // padding: MediaQuery.of(context).viewInsets,
            height: 500,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
            child: AddProducts(),
          );
        }
      );
    }

    return StreamProvider<List<Rasp>>.value(
          value: DatabaseService().rasps,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
              "RasPiFinder",
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              backgroundColor: Colors.blue,
              centerTitle: true,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.add), 
                  label: Text(''),
                  onPressed: () => _showAddPanel(), 
                )
              ],
            ),
            body: RaspList(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
