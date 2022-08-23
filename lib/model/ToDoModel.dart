import 'package:flutter/material.dart';

import 'TaskModel.dart';

class ToDoModel extends ChangeNotifier{
  List<TaskModel> list=[];
  addNewTask(){
    list.add(TaskModel("title ${list.length}", "This is detail no ${list.length}"));
    notifyListeners();
  }

}