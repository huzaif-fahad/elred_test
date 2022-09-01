import 'dart:convert';

class Todo {
  String? title;
  String? description;
  bool? complete;
  String? id;
  DateTime? now;

  Todo({this.complete = false, this.title, this.description, this.now});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      description: json['desc'],
      // now: DateTime.tryParse(json['time'].toString()),
      // complete: json['isComplete']
    );
  }
}
