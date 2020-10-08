import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/screens/auth/components/loading.dart';
import 'package:RasPiFinder/services/database.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/screens/auth/components/shared_constant.dart';
import 'package:provider/provider.dart';
import 'package:RasPiFinder/models/user.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';




class AddProducts extends StatefulWidget {
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {

  final _formKey = GlobalKey<FormState>();
  final List<String> items = ['0', '1', '2', '3', '4'];
  final List<int> availability = [100, 200, 300, 400, 500, 600, 700, 800, 900];

  String _data = "";

  _scan() async{
    await FlutterBarcodeScanner.scanBarcode("#000000", "Cancel", true, ScanMode.BARCODE).then((value) => setState(()=> _data = value));

  }

  // form values
  String _currentModel;
  String _currentName;
  String _currentItems;
  int _currentAvailability;

  @override
  Widget build(BuildContext context) {

    MUser user = Provider.of<MUser>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  _data,
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  initialValue: userData.name,
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField(
                  value: _currentItems ?? '0',
                  decoration: textInputDecoration,
                  items: items.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text('$item items'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _currentItems = val ),
                ),
                SizedBox(height: 10.0),
                Slider(
                  value: (_currentAvailability ?? userData.availability).toDouble(),
                  activeColor: Colors.green[_currentAvailability ?? userData.availability],
                  inactiveColor: Colors.green[_currentAvailability ?? userData.availability],
                  min: 100.0,
                  max: 900.0,
                  divisions: 8,
                  onChanged: (val) => setState(() => _currentAvailability = val.round()),
                ),
                SizedBox(height: 10.0),
                FlatButton.icon( 
                  icon: Icon(Icons.camera_alt), 
                  label: Text('Scan'),
                  onPressed: () {
                    _scan();
                  }
                ),
                RaisedButton(
                  color: Colors.blue[400],
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      await DatabaseService(uid: user.uid).updateUserData(
                        _currentModel ?? snapshot.data.modelNumber,
                        _currentItems ?? snapshot.data.items, 
                        _currentName ?? snapshot.data.name, 
                        _currentAvailability ?? snapshot.data.availability
                      );
                      Navigator.pop(context);
                    }
                  }
                ),
              ],
            ),
          );
        } else {
          return Loading();
        }
      }
    );
  }
}