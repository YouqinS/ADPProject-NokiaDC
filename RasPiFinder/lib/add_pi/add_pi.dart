import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/rounded_button.dart';
import 'package:RasPiFinder/models/user.dart';
import 'package:RasPiFinder/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPi extends StatefulWidget {
  final String modelNumber;
  final GeoPoint geoPoint;
  final UserData scanner;
  AddPi({Key key, this.geoPoint, this.scanner, this.modelNumber}) : super(key: key);

  @override
  AddPiState createState() => new AddPiState(this.geoPoint, this.scanner, this.modelNumber);
}

class AddPiState extends State<AddPi> {
  final String modelNumber;
  final GeoPoint geoPoint;
  final UserData scanner;
  AddPiState(this.geoPoint, this.scanner, this.modelNumber);

  final formKey = GlobalKey<FormState>();
  String address = '', software = '', other = '';
  Map<String, String> user, owner, finder;
  String select = 'Select :', piFinder = 'Pi Finder', piOwner = 'Pi Owner', piUser = 'Pi User', otherType = 'Other';
  String userType = 'Select :';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var textStyle = TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue
                      );
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: PiAppBar(title: 'Fill Pi Info').build(context),
        body: SingleChildScrollView(
          child: Card(
            elevation: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.width * 0.1,),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, size.height * 0.08),
                  //color: Colors.red,
                  child: Text(
                    'Fill info related to this Pi',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 22,
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(width: size.width * 0.02,),
                    Text(
                      'I am a : ',
                      style: textStyle,
                    ),
                    SizedBox(width: size.width * 0.15,),
                    DropdownButton<String>(
                      value: userType,
                      icon: Icon(Icons.keyboard_arrow_down),
                      iconSize: 24,
                      elevation: 16,
                      style: textStyle,
                      underline: Container(
                        height: 2,
                        color: Colors.grey,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          userType = newValue;
                          validateUserTypeInput();
                        });
                      },
                      items: <String>[select, piUser, piFinder, piOwner, otherType]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: '  Pi Location/Address :',
                          labelStyle: textStyle,
                        ),
                        onSaved: (input) => address = input,
                        validator: validateAddressInput,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: '  Software :',
                          labelStyle: textStyle,
                        ),
                        onSaved: (input) => software = input,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: '  Other :',
                          labelStyle: textStyle,
                        ),
                        onSaved: (input) => other = input,
                      ),
                      SizedBox(height: size.height * 0.03),
                      Row(
                        children: [
                          Container(
                            width: size.width * 0.4,
                            child: RoundedButton(
                              color: Colors.red[600],
                              text: 'Cancel',
                              press: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          SizedBox(width: size.width * 0.1),
                          Container(
                            width: size.width * 0.4,
                            child: RoundedButton(
                              text: 'Save',
                              press: () {
                                submit();
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> submit() async {
    if (userType == 'Select :'){
      showAlert();
    }
    if(formKey.currentState.validate() && userType != 'Select :'){
      formKey.currentState.save();
      if (userType == piUser) {
        user = new Map();
        user['username'] = scanner.username;
        user['email'] = scanner.email;
        user['phoneNumber'] = scanner.phoneNumber;
        user['uid'] = scanner.uid;
      }
      if (userType == piOwner) {
        owner = new Map();
        owner['username'] = scanner.username;
        owner['email'] = scanner.email;
        owner['phoneNumber'] = scanner.phoneNumber;
        owner['uid'] = scanner.uid;
      }
      if (userType == piFinder) {
        finder = new Map();
        finder['username'] = scanner.username;
        finder['email'] = scanner.email;
        finder['phoneNumber'] = scanner.phoneNumber;
        finder['uid'] = scanner.uid;
      }
      print('userType=' + userType);
      print('software=' + software);
      print('address=' + address);
      print('geoPoint=' + geoPoint.longitude.toString() + '/' + geoPoint.latitude.toString());
      await DatabaseService().addPi(modelNumber, software, address, owner, user, finder, other, geoPoint);
      Navigator.of(context).pop();
    }
  }

  String validateAddressInput(String address) {
    if (address.isNotEmpty && address.length < 5) {
      return 'Please enter valid Pi location !';
    }
    return null;
  }


  void validateUserTypeInput() {
    if (userType == 'Select :') {
      showAlert();
    }
  }

  Future<void> showAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please select a User Type !'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
