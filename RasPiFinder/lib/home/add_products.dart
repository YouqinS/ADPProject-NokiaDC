import 'package:RasPiFinder/models/rasps.dart';
import 'package:RasPiFinder/components/loading.dart';
import 'package:RasPiFinder/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:RasPiFinder/models/user.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


class AddProducts extends StatefulWidget {

  final Rasp rasp;
  AddProducts([this.rasp]);

  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {


  final _formKey = GlobalKey<FormState>();
  final List<String> roles = ['-','Owner', 'User', 'Finder'];
  final List<int> availability = [100, 200, 300, 400, 500, 600, 700, 800, 900];

  String _data = "";

  // form values
  String _currentModel;
  String _currentName;
  String _currentroles;
  int _currentAvailability;

  final modelController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void dispose() {
    modelController.dispose();
    nameController.dispose();
    super.dispose();
  }

  _scan() async{
    await FlutterBarcodeScanner.scanBarcode("#000000", "Cancel", true, ScanMode.BARCODE)
    .then((value) => setState(() {
      _data = value;
      modelController.text =_data;
      _currentModel = _data;
    })
    );
  }

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
                  "Add product",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: modelController,
                  decoration: InputDecoration(
                    helperText: "Model number"
                  ),
                  validator: (val) => val.isEmpty ? 'Please scan the code' : null,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    helperText: "Name"
                  ),
                  validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField(
                  value: _currentroles ?? '-',
                  decoration: InputDecoration(
                    helperText: "Select a Role" 
                    ),
                  items: roles.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text('$role'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _currentroles = val ),
                ),
                SizedBox(height: 10.0),
                // SliderTheme(
                //   data: SliderTheme.of(context).copyWith(
                //     activeTrackColor: Colors.blue[700],
                //     inactiveTrackColor: Colors.blue[100],
                //     trackShape: RoundedRectSliderTrackShape(),
                //     trackHeight: 4.0,
                //     thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                //     thumbColor: Colors.blueAccent,
                //     overlayColor: Colors.blue.withAlpha(32),
                //     overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                //     tickMarkShape: RoundSliderTickMarkShape(),
                //     activeTickMarkColor: Colors.blue[700],
                //     inactiveTickMarkColor: Colors.blue[100],
                //     valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                //     valueIndicatorColor: Colors.blueAccent,
                //     valueIndicatorTextStyle: TextStyle(
                //       color: Colors.white,
                //     ),
                //   ),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: <Widget>[
                Slider(
                  value: (_currentAvailability ?? userData.availability).toDouble(),
                  activeColor: Colors.blue[_currentAvailability ?? userData.availability],
                  inactiveColor: Colors.blue[_currentAvailability ?? userData.availability],
                  min: 100.0,
                  max: 1000.0,
                  divisions: 4,
                  // label: "$_currentAvailability",
                  onChanged: (val) => setState(() => _currentAvailability = val.round()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Text('Finder'),
                    ),
                    Spacer(),
                    Container(
                      child: Text('User'),
                    ),
                    Spacer(),
                    Container(
                      child: Text('Owner'),
                    ),
                  ],
                ),
                    // ],
                  // )
                // ),
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
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      await DatabaseService(uid: user.uid).updateUserData(
                        _currentModel ?? snapshot.data.modelNumber,
                        _currentroles ?? snapshot.data.roles, 
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