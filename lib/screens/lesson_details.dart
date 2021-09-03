import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:ibis/widget/video_player.dart';
import 'package:video_player/video_player.dart';

class LessonDetails extends StatefulWidget {
  @override
  _LessonDetailsState createState() => _LessonDetailsState();
}

class _LessonDetailsState extends State<LessonDetails> {
  Widget build(BuildContext context) {
    final lessons = ModalRoute.of(context).settings.arguments as Map;

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
                onPressed: () {
                  Navigator.pop(context);
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
