import 'package:flutter/material.dart';
import 'package:ibis/models/courses.dart';
import 'package:ibis/services/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'UTAMA',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                'Kursus SIBI',
                style: Theme.of(context).textTheme.headline2,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text(
                'Mulai belajar Sistem Isyarat Bahasa Indonesia',
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Container(
                height: MediaQuery.of(context).size.height * 0.65,
                child: FutureBuilder<List<Courses>>(
                  future: dataSelect(),
                  builder: (context, snapshot) {
                    return snapshot.data != null
                        ? courseList(snapshot.data)
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Courses>> dataSelect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _edited = (prefs.getBool('edited') ?? false);

    if (_edited) {
      return Services().getData(false);
    } else {
      return Services().getData(true);
    }
  }

  Widget courseList(List<Courses> courses) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/course_details', arguments: {
              'title': courses[index].title,
              'desc': courses[index].description,
              'progress': (courses[index].progress).toStringAsFixed(2),
              'lessons': courses[index].lesson,
            }).then((_) {
              setState(() {});
            });
          },
          child: cardList(
              courses[index].title,
              courses[index].description,
              courses[index].length,
              courses[index].progress >= 100
                  ? 100
                  : (courses[index].progress).toStringAsFixed(2),
              'assets/images/course_' + (index + 1).toString() + '.png'),
        );
      },
    );
  }

  Widget cardList(title, description, length, progress, image) {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(30, 0, 150, 0),
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Color(0xFF6597AF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                '$description',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.alarm_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                  Text(
                    '$length',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  Icon(
                    Icons.check_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                  Text(
                    '$progress %',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          alignment: FractionalOffset.centerRight,
          child: Image(
            image: AssetImage(image),
            height: 180,
            width: 180,
          ),
        ),
      ],
    );
  }
}
