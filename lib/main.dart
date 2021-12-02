import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ibis/screens/course_details.dart';
import 'package:ibis/screens/lesson_details.dart';
import 'package:ibis/screens/onboard.dart';
import 'package:ibis/screens/pageview.dart';
import 'package:ibis/screens/splash.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  await GetStorage.init();
  runApp(IBIS());
}

class IBIS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'IBIS',
      defaultTransition: Transition.rightToLeftWithFade,
      theme: ThemeData(
        primaryColor: Color(0xFF6597AF),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: Color(0xFF6597AF),
          unselectedItemColor: Color(0xFF868686),
          selectedIconTheme: IconThemeData(
            color: Color(0xFF6597AF),
            size: 28,
          ),
          unselectedIconTheme: IconThemeData(
            color: Color(0xFF868686),
            size: 28,
          ),
          selectedLabelStyle: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 12,
            color: Color(0xFF6597AF),
            fontWeight: FontWeight.normal,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 12,
            color: Color(0xFF868686),
            fontWeight: FontWeight.normal,
          ),
        ),
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
      getPages: [
        GetPage(name: '/onboard', page: () => OnboardPage()),
        GetPage(name: '/home', page: () => ScreenControl()),
        GetPage(name: '/course_details', page: () => CourseDetails()),
        GetPage(name: '/lesson_details', page: () => LessonDetails()),
      ],
    );
  }
}
