import 'package:RasPiFinder/profile/my_pi.dart';
import 'package:RasPiFinder/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/home/home_page.dart';
import 'package:RasPiFinder/profile/profile.dart';
import 'package:provider/provider.dart';
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
    final UserData userData = Provider.of<UserData>(context);

    String uid = "";
    if (userData != null) {
      uid = userData.uid;
    }

    List<Widget> _screens = [HomePage(), Profile(), MyRasPi(uid: uid,)];

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
          selectedItemColor: AppTheme.iconColors[0],
          onTap: _onItemTapped,
        ),
    );
  }
}
