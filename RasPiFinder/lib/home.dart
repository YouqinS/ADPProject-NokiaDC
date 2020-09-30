import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Text('RasPiFinder'),
            ]
      ),
    ),
      body: Center(
        child: _image == null
            ? Text('Click the Scan button to open camera',
            style: new TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            :Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon:Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: getImage,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.search),
            title: new Text('Search'),
          ),
        ],
      ),
    );
  }
}
