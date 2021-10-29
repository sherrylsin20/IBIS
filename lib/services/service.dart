import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:ibis/models/courses.dart';

import 'package:path_provider/path_provider.dart';

class Services {
  Future<String> _loadJson() async {
    return await rootBundle.loadString('assets/data/list_courses.json');
  }

  Future<String> _loadEditedJson() async {
    Directory dir = await getExternalStorageDirectory();
    String path = dir.path;
    File jsonFile = File(path + '/list_courses.json');
    return jsonFile.readAsStringSync();
  }

  Future<List<Courses>> getData(bool status) async {
    List<Courses> list;

    var data = status
        ? jsonDecode(await _loadEditedJson())
        : jsonDecode(await _loadJson());
    var res = status ? data : data['courses'] as List;
    list = res.map<Courses>((json) => Courses.fromJson(json)).toList();
    return list;
  }

  // Updating data
  Future updatedata(
      String title, double progress, String name, int length) async {
    bool exist = false;
    List<Courses> list;
    print('Updating data');

    // Accessing external storage directory
    Directory dir = await getExternalStorageDirectory();
    String path = dir.path;
    print(path);
    // Checking if file exists or not
    File file = new File(path + '/list_courses.json');
    exist = file.existsSync();
    print(exist);

    if (exist) {
      var data = jsonDecode(await _loadEditedJson());
      var res = data as List;
      print(res);
      list = res.map<Courses>((json) => Courses.fromJson(json)).toList();

      // Update progress courses
      list.firstWhere((element) => element.title == title).progress +=
          100 / length;

      // Update status lesson
      var index = list.indexWhere((element) => element.title == title);
      print(index);
      list[index].lesson.firstWhere((element) => element.name == name).status =
          true;

      // Simpen updated file
      File jsonFile = File(path + '/list_courses.json');
      jsonFile.writeAsStringSync(json.encode(list));
    } else {
      print('creating file');
      file.createSync();
      exist = true;
      file.writeAsStringSync(_loadJson().toString());

      var data = jsonDecode(await _loadJson());
      var res = data['courses'] as List;
      list = res.map<Courses>((json) => Courses.fromJson(json)).toList();
      print(res);

      list.firstWhere((element) => element.title == title).progress +=
          (1 / length) * 100;

      var index = list.indexWhere((element) => element.title == title);
      print(index);

      list[index].lesson.firstWhere((element) => element.name == name).status =
          true;

      //list.firstWhere((element) =>
      //element.lesson.firstWhere((e) => e.name == name).status = true);

      File jsonFile = File(path + '/list_courses.json');
      jsonFile.writeAsStringSync(json.encode(list));
    }
  }
}
