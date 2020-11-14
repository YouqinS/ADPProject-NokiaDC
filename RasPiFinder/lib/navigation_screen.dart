import 'package:RasPiFinder/profile/my_pi.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/home/home_page.dart';
import 'package:RasPiFinder/profile/profile.dart';
import 'package:provider/provider.dart';
import 'models/rasps.dart';
import 'models/user.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

  PageController _pageController = PageController();

  int _selectedIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    final List<Rasp> piCollectionFromDB = Provider.of<List<Rasp>>(context) ?? [];
    final UserData userData = Provider.of<UserData>(context);

    List<Rasp> myPies = [];
    if (userData != null) {
      myPies = getMyPiList(userData.uid, piCollectionFromDB);
    }

    List<Widget> _screens = [HomePage(), Profile(userData: userData,), MyRasPi(myPies: myPies,)];


    return Scaffold(
        body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: _onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
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
              icon: new Icon(Icons.pie_chart_outline_outlined),
              label: 'MyPies',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
    );
  }

//TODO: get 'myPies' by querying db straight?
  List<Rasp> getMyPiList(String userUid, List<Rasp> piCollectionFromDB) {
    final List<Rasp> myPies = [];
    for (int i=0; i<piCollectionFromDB.length; i++) {
      if ((piCollectionFromDB[i].user != null && piCollectionFromDB[i].user['uid'] ==  userUid) ||
          (piCollectionFromDB[i].finder != null && piCollectionFromDB[i].finder['uid'] == userUid) ||
          (piCollectionFromDB[i].owner != null && piCollectionFromDB[i].owner['uid'] == userUid)) {
        myPies.add(piCollectionFromDB[i]);
      }
    }
    return myPies;
  }
}
