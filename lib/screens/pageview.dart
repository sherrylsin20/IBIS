import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ibis/screens/camera.dart';
import 'package:ibis/screens/home.dart';
import 'package:ibis/screens/information.dart';
import 'package:ibis/services/recognition.dart';
import 'package:ibis/services/stats.dart';
import 'package:ibis/widget/bounding_box.dart';

class ScreenControl extends StatefulWidget {
  @override
  _ScreenControlState createState() => _ScreenControlState();
}

class _ScreenControlState extends State<ScreenControl> {
  List<Recognition> results;
  Stats stats;
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
          children: <Widget>[
            HomePage(),
            Stack(
              children: [
                CameraPage(resultsCallback, statsCallback),
                boundingBoxes(results),
              ],
            ),
            InfoPage()
          ],
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
              label: 'Kamera',
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
              label: 'Informasi',
              icon: Icon(
                Icons.info_rounded,
                size: 32,
                color: Color(0xFF868686),
              ),
              activeIcon: Icon(
                Icons.info_rounded,
                size: 32,
                color: Color(0xFF6597AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget boundingBoxes(List<Recognition> results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results
          .map((e) => BoxWidget(
                result: e,
              ))
          .toList(),
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

  void resultsCallback(List<Recognition> results) {
    setState(() {
      this.results = results;
    });
  }

  /// Callback to get inference stats from [CameraView]
  void statsCallback(Stats stats) {
    setState(() {
      this.stats = stats;
    });
  }
}
