import 'package:RasPiFinder/models/rasps.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:RasPiFinder/services/database.dart';
import 'package:provider/provider.dart';
import 'package:RasPiFinder/screens/home/rasp_list.dart';
import 'package:RasPiFinder/screens/home/product_details.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
  with AutomaticKeepAliveClientMixin {  

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            ),
            body: RaspList(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
