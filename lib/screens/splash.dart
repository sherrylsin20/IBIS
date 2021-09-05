import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ibis/screens/home.dart';
import 'package:ibis/screens/onboard.dart';
import 'package:ibis/screens/pageview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
    print('init splash');
  }

  @override
  void dispose() {
    print('dispose splash');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF6597AF),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/ibis_logo_white.png',
                height: 150,
                width: 150,
              ),
              Text(
                'ibis',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 32,
                  color: Colors.white,
                  letterSpacing: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 5);
    return Timer(duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (!_seen) {
      prefs.setBool('seen', true);
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => OnboardPage()));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => ScreenControl()));
    }
  }
}
