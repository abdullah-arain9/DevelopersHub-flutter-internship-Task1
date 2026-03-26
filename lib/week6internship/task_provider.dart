import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  List<String> tasks = [];

  addTask(String task) {
    tasks.add(task);
    notifyListeners();
  }

  removeTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }

  updateTask(int index, String newTask) {
    tasks[index] = newTask;
    notifyListeners();
  }
}