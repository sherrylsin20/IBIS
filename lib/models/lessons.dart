class Lessons {
  String name;
  String explanation;
  String link;
  bool status;

  Lessons({this.name, this.explanation, this.link, this.status});

  factory Lessons.fromJson(Map<String, dynamic> json) {
    return Lessons(
        name: json['name'],
        explanation: json['explanation'],
        link: json['video'],
        status: json['status']);
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'explanation': explanation,
        'video': link,
        'status': status
      };
}
