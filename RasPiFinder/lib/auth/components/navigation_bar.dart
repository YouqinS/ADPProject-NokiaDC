import 'package:RasPiFinder/auth/components/app_bar.dart';
import 'package:RasPiFinder/home/home_page.dart';
import 'package:RasPiFinder/profile/profile.dart';
import 'package:RasPiFinder/search/search.dart';
import 'package:flutter/material.dart';

class NavPage extends StatefulWidget {
  @override
  NavPageState createState() => NavPageState();
}

class NavPageState extends State<NavPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    ProfilePage(),
    SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: piAppBar,
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
