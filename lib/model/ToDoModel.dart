import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'TaskModel.dart';

class ToDoModel extends ChangeNotifier {
  List<TaskModel> taskModel = [];
  static var db = FirebaseFirestore.instance;
  var tasksCollection = db.collection("tasks");
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? tasksStream;

  ToDoModel() {
    getTasksData();
  }

  Future<void> getTasksData() async {
    tasksStream = tasksCollection.snapshots().listen((value) {
      taskModel = [];
      List<TaskModel> list = [];
      value.docs.forEach((element) {
        TaskModel model = TaskModel.fromMap(element.data());
        model.id = element.id;
        list.add(model);
        taskModel = list;
      });
      notifyListeners();
    });
    print("Length of model is ${taskModel.length}");
  }

  Future<void> addNewTask(String title, String detail) async {
    var model = TaskModel(title, detail);
    var doc = tasksCollection.doc();
    try {
      doc.set(model.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateTask(int index, bool val) async {
    try {
      TaskModel model = taskModel[index];
      model.setCheck = val;
      tasksCollection.doc(model.id).update({'check': val});
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<void> removeTask(int index) async {
    try {
      var model = taskModel[index];
      tasksCollection.doc(model.id).delete();
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  @override
  void dispose() {
    tasksStream?.cancel();
    super.dispose();
  }
}
