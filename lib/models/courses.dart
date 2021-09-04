import 'dart:convert';

import 'package:ibis/models/lessons.dart';

class Courses {
  String title;
  String description;
  String length;
  double progress;
  List<Lessons> lesson;

  Courses(
      {this.title, this.description, this.length, this.progress, this.lesson});

  factory Courses.fromJson(Map<String, dynamic> json) {
    var list = json['lessons'] as List;
    List<Lessons> lessonList = list.map((i) => Lessons.fromJson(i)).toList();

    return Courses(
        title: json['title'],
        description: json['description'],
        length: json['length'],
        progress: json['progress'],
        lesson: lessonList);
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'length': length,
        'progress': progress,
        'lessons': List<dynamic>.from(lesson.map((e) => e.toJson())),
      };
}
