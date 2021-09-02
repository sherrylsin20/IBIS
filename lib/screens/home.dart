import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              SizedBox(height: 0.05),
              Text(
                'Kursus SIBI',
                style: Theme.of(context).textTheme.headline2,
              ),
              Text(
                'Mulai belajar Sistem Isyarat Bahasa Indonesia',
                style: Theme.of(context).textTheme.caption,
              ),
              cardList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardList() {
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Color(0xFF6597AF),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }
}
