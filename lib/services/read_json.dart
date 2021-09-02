import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ibis/models/courses.dart';

class ReadJSON {
  Future<String> _loadJson() async {
    return await rootBundle.loadString('assets/data/list_courses.json');
  }

  Future<List<Courses>> _getData() async {
    List<Courses> list;

    var data = jsonDecode(await _loadJson());
    var res = data['courses'] as List;
    print(res);
    list = res.map<Courses>((json) => Courses.fromJson(json)).toList();

    return list;
  }
}
