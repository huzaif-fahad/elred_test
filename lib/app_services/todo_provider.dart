import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elred_test/app_constants/error_screen.dart';
import 'package:elred_test/app_models/todo_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class StateProvider with ChangeNotifier {
  List<Todo> items = List<Todo>.empty(growable: true);

  List<Todo> completedItems = List<Todo>.empty(growable: true);

  final collection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('todos');

  final completedCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('Completed Todos');

  getData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('todos')
        .orderBy('time', descending: false)
        .get();
    for (var i = 0; i < snapshot.docs.length; i++) {
      items = snapshot.docs
          .map((d) => Todo.fromJson(d.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    }
  }

  void editTask(Todo item, String description, String title) {
    if (description != '') {
      item.description = description;
      collection.doc().set({'desc': description, 'title': item.title});
      notifyListeners();
    }
    if (title != '') {
      item.title = title;
      notifyListeners();
    }
  }

  void removeItem(Todo item) async {
    await collection.doc(item.id).delete();
    items.remove(item);
    notifyListeners();
  }

  void addNewTask(Todo todo) async {
    var now = DateTime.now();

    if (todo.description != '') {
      await collection.add({
        'title': todo.title,
        'desc': todo.description,
        'time': now,
        'isComplete': false
      }).then((value) {
        todo.id = value.id;
        items.add(todo);
      });

      notifyListeners();
    }
  }

  void chanceCompleteness(Todo item) async {
    item.complete == true;
    await collection.doc(item.id).update({'isComplete': true});
    removeItem(item);
    var now = DateTime.now();
    completedCollection.add({
      'title': item.title,
      'desc': item.description,
      'time': now,
      'isComplete': false
    }).then((value) {
      item.id = value.id;
      notifyListeners();
    });
  }
}
