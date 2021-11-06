import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ibis/models/courses.dart';
import 'package:ibis/services/service.dart';
import 'package:path_provider/path_provider.dart';

class IBISPresenter extends GetxController {
  GetStorage storage = GetStorage();
  bool _updated;
  final courseList = Future.value().obs;

  void onInit() {
    super.onInit();
    _updated = storage.read('updated') ?? false;
    print(_updated);
    getList(_updated);
  }

  void getList(status) async {
    courseList.value = Services().getData(status);
  }

  void updateJson(title, progress, name, length) async {
    Services().updatedata(title, progress, name, length);
    _updated = storage.read('updated') ?? false;
    getList(_updated);
  }
}
