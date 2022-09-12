import 'package:checklife/util/formatting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.model.dart';

class TaskService {
  FirebaseFirestore bd = FirebaseFirestore.instance;
  Formatting formatting = Formatting();

  getTasks(DateTime date) async {
    var collection = await bd
        .collection("tasks")
        .where("date", isEqualTo: formatting.formatDate(date))
        .get();

    List<Task> tasks = [];

    for (var doc in collection.docs) {
      Task task = Task.fromMap(doc.data());
      tasks.add(task);
    }

    return tasks;
  }

  getPendentTasks(DateTime date) async {
    var collection = await bd
        .collection("tasks")
        .where("date", isEqualTo: formatting.formatDate(date))
        .where("closed", isEqualTo: false)
        .get();

    List<Task> tasks = [];

    for (var doc in collection.docs) {
      Task task = Task.fromMap(doc.data());
      tasks.add(task);
    }

    return tasks;
  }

  createTask(Task task, DateTime date, int index) async {
    String taskCode = (index).toString().padLeft(5, '0');
    String taskDate = formatting.formatDate(date);

    String id = "$taskDate $taskCode";

    Task newTask = Task(
      date: taskDate,
      title: task.title,
      id: id,
      closed: false,
      description: "",
      createdAt: task.createdAt,
    );

    await bd
        .collection("tasks")
        .doc("$taskDate $taskCode")
        .set(newTask.toMap());

    return newTask;
  }

  deleteTask(String id) async {
    await bd.collection("tasks").doc(id).delete();
  }

  getLastUpdate() async {
    var doc = await bd.collection("config").doc("config").get();
    var lastUpdate = doc.data()!["lastUpdate"];
    return DateTime.parse(lastUpdate);
  }

  setLastUpdate(DateTime date) async {
    await bd
        .collection("config")
        .doc("config")
        .update({"lastUpdate": formatting.formatDate(date)});
  }
}
