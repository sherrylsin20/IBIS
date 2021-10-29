import 'package:flutter/material.dart';
import 'package:ibis/models/faq.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  'TENTANG KAMI',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      )),
                  Image.asset(
                    'assets/images/ibis_logo_white.png',
                    height: 75,
                    width: 75,
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                'IBIS: SIBI Translator',
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                'Version 1.0.0',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              faqs(),
            ],
          ),
        ),
      ),
    );
  }

  Widget faqs() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      child: ListView.builder(
        itemCount: faqsItems.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionPanelList(
            animationDuration: Duration(seconds: 1),
            dividerColor: Colors.white,
            elevation: 0,
            children: [
              ExpansionPanel(
                canTapOnHeader: true,
                isExpanded: faqsItems[index].isExpanded,
                backgroundColor:
                    index % 2 == 0 ? Color(0xFF6597AF) : Color(0xFFDDDDDD),
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: index % 2 == 0
                          ? Color(0xFF6597AF)
                          : Color(0xFFDDDDDD),
                    ),
                    width: double.infinity,
                    height: 50,
                    child: Text(
                      faqsItems[index].headerItem,
                      style: index % 2 == 0
                          ? Theme.of(context).textTheme.headline3
                          : Theme.of(context).textTheme.headline4,
                    ),
                  );
                },
                body: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: Text(
                    faqsItems[index].content,
                    textAlign: TextAlign.justify,
                    style: index % 2 == 0
                        ? Theme.of(context).textTheme.bodyText1
                        : Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
            ],
            expansionCallback: (int item, bool status) {
              setState(() {
                faqsItems[index].isExpanded = !faqsItems[index].isExpanded;
              });
            },
          );
        },
      ),
    );
  }

  List<FAQ> faqsItems = <FAQ>[
    FAQ(
        headerItem: 'Apa itu IBIS?',
        content:
            'IBIS adalah aplikasi untuk menerjemahkan Sistem Isyarat Bahasa Indonesia menggunakan kamera smartphone secara langsung. Selain itu IBIS juga menyediakan kursus bahasa isyarat yang bisa diikuti pengguna untuk mengembangkan keahlian berbahasa isyarat.'),
    FAQ(
        headerItem: 'Filosofi logo dan nama IBIS?',
        content:
            'Logo IBIS terinspirasi dari burung Ibis. Burung Ibis pada mitologi Mesir yang melambangkan dewa kebijakan dan menulis. Pada logo juga terdapat huruf I, B, dan S yang membentuk nama IBIS. Nama IBIS selain diambil dari burung Ibis, merupakan palindrome dari kata SIBI.'),
    FAQ(
        headerItem: 'Cara menggunakan aplikasi?',
        content:
            'Untuk menggunakan kamera terjemahan, cukup buka menu kamera dan arahkan ke penggestur. Kata akan langsung muncul sebagai teks di bawah kamera. Untuk menggunakan fitur kursus cukup pilih salah satu kursus dan materi lalu ikuti video beserta penjelasannya.'),
    FAQ(
        headerItem: 'Bahasa isyarat yang digunakan?',
        content:
            'IBIS menggunakan Sistem Isyarat Bahasa Indonesia (SIBI) karena SIBI ditetapkan sebagai sistem isyarat bagi kaum tunarungu yang sesuai dengan kurikulum yang berlaku dan bersifat nasional.'),
  ];
}
