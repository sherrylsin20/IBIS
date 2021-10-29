import 'package:flutter/material.dart';
import 'package:ibis/screens/camera.dart';
import 'package:ibis/screens/home.dart';
import 'package:ibis/screens/information.dart';

class ScreenControl extends StatefulWidget {
  @override
  _ScreenControlState createState() => _ScreenControlState();
}

class _ScreenControlState extends State<ScreenControl> {
  int _page = 0;
  PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            onPageChanged(index);
          },
          children: <Widget>[HomePage(), CameraPage(), SettingsPage()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _page,
          onTap: (index) {
            setState(() {
              _page = index;
              bottomTapped(index);
            });
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(
                Icons.home_rounded,
                size: 32,
                color: Color(0xFF868686),
              ),
              activeIcon: Icon(
                Icons.home_rounded,
                size: 32,
                color: Color(0xFF6597AF),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Camera',
              icon: Icon(
                Icons.camera_alt_rounded,
                size: 32,
                color: Color(0xFF868686),
              ),
              activeIcon: Icon(
                Icons.camera_alt_rounded,
                size: 32,
                color: Color(0xFF6597AF),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(
                Icons.settings_rounded,
                size: 32,
                color: Color(0xFF868686),
              ),
              activeIcon: Icon(
                Icons.settings_rounded,
                size: 32,
                color: Color(0xFF6597AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onPageChanged(int index) {
    setState(() {
      _page = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _page = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    });
  }
}
