import 'dart:io';

import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:RasPiFinder/pi_data/pi_data.dart';
import 'package:RasPiFinder/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PiAppBar(title: 'RasPiFinder',).build(context),
      body: Center(
        child: _image == null
            ? Text('Click the Scan button to open camera',
            style: new TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            :Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon:Icon(Icons.camera_alt),
        label: Text("Scan"),
        //TODO add function to scan qr code
        //onPressed: getImage,
        onPressed: () {
          //for temporary testing
          navigateToPage(context, PiData());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}
