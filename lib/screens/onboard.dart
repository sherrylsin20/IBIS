import 'package:flutter/material.dart';
import 'package:ibis/models/pages.dart';
import 'package:ibis/screens/home.dart';
import 'dart:math';
import 'package:liquid_swipe/liquid_swipe.dart';

class OnboardPage extends StatefulWidget {
  @override
  _OnboardPageState createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  int page = 0;
  LiquidController liquidController;
  UpdateType updateType;

  List<Pages> pagesItem = [
    Pages('translate', 'Terjemahkan',
        'Terjemahkan Bahasa Isyarat Indonesia secara real-time menggunakan kamera'),
    Pages('learn', 'Belajar',
        'Ikuti kursus untuk mulai mengerti Bahasa Isyarat Indonesia agar bisa berkomunikasi secara langsung'),
    Pages('share', 'Berbagi',
        'Ajarkan teman-teman dengan pengetahuan yang kamu dapat. Mulai sebarkan kesadaran tentang pentingnya belajar Bahasa Isyarat Indonesia')
  ];

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: <Widget>[
            LiquidSwipe.builder(
              enableLoop: false,
              onPageChangeCallback: pageChangeCallback,
              waveType: WaveType.liquidReveal,
              liquidController: liquidController,
              ignoreUserGestureWhileAnimating: true,
              itemCount: pagesItem.length,
              itemBuilder: (context, index) {
                return pages(pagesItem[index].image, pagesItem[index].title,
                    pagesItem[index].caption);
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.1),
              child: Align(
                alignment: Alignment.center,
                child: Column(children: <Widget>[
                  Expanded(child: SizedBox()),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          List<Widget>.generate(pagesItem.length, _buildDot)),
                ]),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: page == pagesItem.length - 1
                  ? TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/home');
                      },
                      child: Text("Go to app",
                          style: Theme.of(context).textTheme.headline6),
                    )
                  : Container(
                      height: 50,
                      width: 50,
                      child: RawMaterialButton(
                        onPressed: () {
                          liquidController.animateToPage(
                              page: liquidController.currentPage + 1);
                        },
                        fillColor: Color(0xFF6597AF),
                        child: Icon(
                          Icons.keyboard_arrow_right_rounded,
                          size: 32,
                          color: Colors.white,
                        ),
                        shape: CircleBorder(
                            side: BorderSide(
                          color: Colors.transparent,
                          width: 0,
                        )),
                      ),
                    ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget pages(image, title, caption) {
    return Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image(
              image: AssetImage(
                'assets/images/$image.png',
              ),
              width: MediaQuery.of(context).size.width * 0.9,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              caption,
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.justify,
            ),
          ]),
    );
  }

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page ?? 0) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return new Container(
      width: 25.0,
      child: new Center(
        child: new Material(
          color: Color(0xFF6597AF),
          type: MaterialType.circle,
          child: new Container(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }
}
