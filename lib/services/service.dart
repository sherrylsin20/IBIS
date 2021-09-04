import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibis/models/courses.dart';
import 'package:ibis/models/lessons.dart';

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
        ? jsonDecode(await _loadJson())
        : jsonDecode(await _loadEditedJson());
    var res = status ? data['courses'] as List : data;
    list = res.map<Courses>((json) => Courses.fromJson(json)).toList();
    return list;
  }

  Future updatedata(
      String title, double progress, String name, int length) async {
    print(length);
    bool exist = false;
    List<Courses> list;
    print('Updating data');

    // Akses direktori data aplikasi
    Directory dir = await getExternalStorageDirectory();
    String path = dir.path;

    // Check file ada ato belom
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
      list.firstWhere(
          (element) =>
              element.lesson.firstWhere((e) => e.name == name).status = true,
          orElse: () => null);

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

      list.firstWhere((element) => element.title == title).progress +=
          (1 / length) * 100;

      list.firstWhere((element) =>
          element.lesson.firstWhere((e) => e.name == name).status = true);
      File jsonFile = File(path + '/list_courses.json');
      jsonFile.writeAsStringSync(json.encode(list));
    }
  }
}
