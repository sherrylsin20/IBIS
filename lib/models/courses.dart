import 'package:ibis/models/lessons.dart';

class Courses {
  final String title;
  final String description;
  final String length;
  final int progress;
  final List<Lessons> lesson;

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
}
