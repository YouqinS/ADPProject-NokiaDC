import 'dart:io';

import 'package:RasPiFinder/components/app_bar.dart';
import 'package:RasPiFinder/components/navigate.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:RasPiFinder/app_user/app_user.dart';

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
      appBar: piAppBar,
      body: Column(children: ListTile.divideTiles(context: context, tiles: [
      ListTile(
          leading: Image.network(
              "https://cdn4.iconfinder.com/data/icons/flat-brand-logo-2/512/nokia-512.png"),
          title: Text('Product 1'),
          subtitle: Text('1234567'),
          trailing: Icon(Icons.chevron_right)),
      ListTile(
          leading: Image.network(
              "https://cdn4.iconfinder.com/data/icons/flat-brand-logo-2/512/nokia-512.png"),
          title: Text('Product 2'),
          subtitle: Text('1234567'),
          trailing: Icon(Icons.chevron_right)),
      ListTile(
          leading: Image.network(
              "https://cdn4.iconfinder.com/data/icons/flat-brand-logo-2/512/nokia-512.png"),
          title: Text('Product 3'),
          subtitle: Text('1234567'),
          trailing: Icon(Icons.chevron_right)),
      ListTile(
          leading: Image.network(
              "https://cdn4.iconfinder.com/data/icons/flat-brand-logo-2/512/nokia-512.png"),
          title: Text('Product 4'),
          subtitle: Text('1234567'),
          trailing: Icon(Icons.chevron_right)),
      ListTile(
          leading: Image.network(
              "https://cdn4.iconfinder.com/data/icons/flat-brand-logo-2/512/nokia-512.png"),
          title: Text('Product 5'),
          subtitle: Text('1234567'),
          trailing: Icon(Icons.chevron_right)),
        ListTile(
            leading: Image.network(
                "https://cdn4.iconfinder.com/data/icons/flat-brand-logo-2/512/nokia-512.png"),
            title: Text('Product 6'),
            subtitle: Text('1234567'),
            trailing: Icon(Icons.chevron_right)),
        ListTile(
            leading: Image.network(
                "https://cdn4.iconfinder.com/data/icons/flat-brand-logo-2/512/nokia-512.png"),
            title: Text('Product 7'),
            subtitle: Text('1234567'),
            trailing: Icon(Icons.chevron_right)),
      ]).toList(),
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon:Icon(Icons.camera_alt),
        label: Text("Scan"),
        tooltip: ('Open camera to scan a QR code'),
        //TODO add function to scan qr code
        //onPressed: getImage,
        onPressed: () {
          //for temporary testing
          navigateToPage(context, AppUser());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text("Profile"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.search),
            title: new Text("Search"),
          ),
        ],
      ),
    );
  }
}
