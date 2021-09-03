import 'package:flutter/material.dart';
import 'package:ibis/screens/course_details.dart';
import 'package:ibis/screens/home.dart';
import 'package:ibis/screens/lesson_details.dart';
import 'package:ibis/screens/onboard.dart';
import 'package:ibis/screens/splash.dart';

void main() {
  runApp(IBIS());
}

class IBIS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IBIS',
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 24,
              color: Color(0xFF6597AF),
              fontWeight: FontWeight.bold,
              letterSpacing: 10),
          headline2: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 24,
            color: Color(0xFF6597AF),
            fontWeight: FontWeight.bold,
          ),
          headline3: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          headline4: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 16,
            color: Color(0xFF6597AF),
            fontWeight: FontWeight.bold,
          ),
          headline5: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          headline6: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 12,
            color: Color(0xFF6597AF),
            fontWeight: FontWeight.bold,
          ),
          caption: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 16,
            color: Color(0xFF6597AF),
            fontWeight: FontWeight.normal,
          ),
          subtitle1: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 16,
            color: Color(0xFF41616F),
            fontWeight: FontWeight.normal,
          ),
          bodyText1: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
          bodyText2: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 12,
            color: Color(0xFF6597AF),
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      home: SplashScreen(),
      routes: {
        '/onboard': (context) => OnboardPage(),
        '/home': (context) => HomePage(),
        '/course_details': (context) => CourseDetails(),
        '/lesson_details': (context) => LessonDetails(),
      },
    );
  }
}
