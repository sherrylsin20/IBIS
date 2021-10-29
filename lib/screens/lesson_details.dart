import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ibis/controller/controller.dart';
import 'package:ibis/services/service.dart';
import 'package:ibis/widget/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonDetails extends StatefulWidget {
  @override
  _LessonDetailsState createState() => _LessonDetailsState();
}

class _LessonDetailsState extends State<LessonDetails> {
  Map<String, dynamic> jsonFile;

  @override
  void initstate() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final lessons = Get.arguments as Map;
    final controller = Get.put(IBISController());
    GetStorage box = GetStorage();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: VideoWidget(
                    link:
                        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                  )),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                lessons['name'],
                style: Theme.of(context).textTheme.headline2,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text(
                lessons['desc'],
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              TextButton(
                onPressed: () async {
                  box.write('updated', true);
                  if (lessons['status']) {
                    print(lessons['status']);
                    Get.offAllNamed('/home');
                  } else {
                    controller.updateJson(
                        lessons['title'],
                        double.parse(lessons['progress']),
                        lessons['name'],
                        lessons['length']);
                    controller.update();
                    Get.offAllNamed('/home');
                  }
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF6597AF))),
                child: Text(
                  'Selesai',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
