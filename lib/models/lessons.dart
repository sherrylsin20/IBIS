class Lessons {
  final String name;
  final String explanation;
  final String link;
  final bool status;

  Lessons({this.name, this.explanation, this.link, this.status});

  factory Lessons.fromJson(Map<String, dynamic> json) {
    return Lessons(
        name: json['name'],
        explanation: json['explanation'],
        link: json['video'],
        status: json['status']);
  }
}
