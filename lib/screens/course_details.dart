import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseDetails extends StatefulWidget {
  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  var _counter = 0;

  void initState() {
    _counter++;
    super.initState();
  }

  Widget build(BuildContext context) {
    final courses = Get.arguments as Map;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Text(
                courses['title'],
                style: Theme.of(context).textTheme.headline2,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                courses['desc'],
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    double.parse(courses['progress']) >= 100
                        ? '100 %'
                        : courses['progress'].toString() + '%',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: LinearProgressIndicator(
                        value: double.parse(courses['progress']) / 100,
                        minHeight: 10,
                        backgroundColor: Color(0xFFDDDDDD),
                        valueColor: AlwaysStoppedAnimation(Color(0xFF6597AF)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              Expanded(
                child: lessonList(courses['lessons'], courses['title'],
                    courses['progress'], courses['lessons'].length),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget lessonList(lessons, title, progress, length) {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Get.toNamed('/lesson_details', arguments: {
              'name': lessons[index].name,
              'desc': lessons[index].explanation,
              'link': lessons[index].link,
              'status': lessons[index].status,
              'title': title,
              'progress': progress,
              'length': length,
            }).then((_) => setState(() {}));
          },
          child: Scrollbar(
              child: cardList(lessons[index].name, lessons[index].status)),
        );
      },
    );
  }

  Widget cardList(name, status) {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: status ? Color(0xFF6597AF) : Color(0xFFDDDDDD),
          ),
          width: double.infinity,
          height: 50,
          child: Text(
            name,
            style: status
                ? Theme.of(context).textTheme.headline3
                : Theme.of(context).textTheme.headline4,
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            alignment: FractionalOffset.centerRight,
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.check_circle_outline_rounded,
              color: status ? Colors.white : Color(0xFFDDDDDD),
              size: 32,
            )),
      ],
    );
  }
}
