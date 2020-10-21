import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/components/rounded_button.dart';
import 'package:RasPiFinder/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppUser extends StatefulWidget {
  AppUser({Key key}) : super(key: key);

  @override
  PiUserInfo createState() => new PiUserInfo();
}

class PiUserInfo extends State<AppUser> {
  final formKey = GlobalKey<FormState>();
  String address, software, other;
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
                      items: <String>['Select :', 'Pi Finder', 'Pi Owner', 'Pi User']
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
                      Container(
                          width: size.width * 0.5,
                          child: RoundedButton(
                            text: 'Save',
                            press: () {
                              submit();
                            },
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void submit(){
    if (userType == 'Select :'){
      showAlert();
    }
    if(formKey.currentState.validate() && userType != 'Select :'){
      formKey.currentState.save();
      //TODO get current GPS data and store to DB
      //TODO connect to DB to store user input
      print(userType);
      print(software);
      print(address);
      navigateToPage(context, HomePage());
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
