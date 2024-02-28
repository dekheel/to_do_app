import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/firebaseUtils.dart';
import 'package:to_do_app/model/task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> taskList = [];

  DateTime initialDate = DateTime.now();

  getAllFirebaseTasks(String uid) async {
    QuerySnapshot<Task> querySnapshot =
        await FirebaseUtils.getTasksCollection(uid).get();

    taskList = querySnapshot.docs.map((task) {
      return task.data();
    }).toList();

    // sort taskList
    taskList.sort(
      (a, b) {
        return a.date!.compareTo(b.date!);
      },
    );

    taskList = taskList.where((task) {
      return (task.date?.day == initialDate.day &&
          task.date?.month == initialDate.month &&
          task.date?.year == initialDate.year);
    }).toList();

    // sort by firebase
    // QuerySnapshot<Task> querySnapshot1 =
    //     await FirebaseUtils.getTasksCollection()
    //         .orderBy("date", descending: false)
    //         .get();

    // filter by firebase
    // QuerySnapshot<Task> querySnapshot2 =
    //     await FirebaseUtils.getTasksCollection()
    //         .where("date",
    //             isEqualTo:
    //                 initialDate.millisecondsSinceEpoch)
    //         .get();

    notifyListeners();
  }

  void changeInitialDate(DateTime newDate, String uid) {
    initialDate = newDate;
    getAllFirebaseTasks(uid);
    notifyListeners();
  }
}
