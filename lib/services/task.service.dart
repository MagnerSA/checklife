import 'package:checklife/util/formatting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/task.model.dart';

class TaskService {
  FirebaseFirestore bd = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Formatting formatting = Formatting();

  getTasks(DateTime date) async {
    var collection = await bd
        .collection("users")
        .doc(auth.currentUser?.uid)
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
        .collection("users")
        .doc(auth.currentUser?.uid)
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

  createTask(Task task, DateTime date) async {
    int index = await _getNextTaskIndex(date);

    String taskCode = (index).toString().padLeft(5, '0');
    String taskDate = formatting.formatDate(date);

    String id = "$taskDate $taskCode";

    Task newTask = Task(
      type: task.type,
      date: taskDate,
      title: task.title,
      id: id,
      closed: false,
      description: "",
      closedAt: "",
      createdAt: task.createdAt,
    );

    await bd
        .collection("users")
        .doc(auth.currentUser?.uid)
        .collection("tasks")
        .doc("$taskDate $taskCode")
        .set(newTask.toMap());

    return newTask;
  }

  deleteTask(String id) async {
    await bd
        .collection("users")
        .doc(auth.currentUser?.uid)
        .collection("tasks")
        .doc(id)
        .delete();
  }

  getLastUpdate() async {
    var doc = await bd.collection("users").doc(auth.currentUser?.uid).get();
    var lastUpdate = doc.data()!["lastUpdate"];
    return DateTime.parse(lastUpdate);
  }

  setLastUpdate(DateTime date) async {
    await bd
        .collection("users")
        .doc(auth.currentUser?.uid)
        .update({"lastUpdate": formatting.formatDate(date)});
  }

  updateTask(Task task) async {
    await bd
        .collection("users")
        .doc(auth.currentUser?.uid)
        .collection("tasks")
        .doc(task.id)
        .set(task.toMap());
  }

  realocateTask(Task task, DateTime date) async {
    print("Realocando task: ${task.title}");
    print("Para o dia ${date.toString()}");

    await deleteTask(task.id);
    Task newTask = await createTask(task, date);

    return newTask;
  }

  _getNextTaskIndex(DateTime date) async {
    var tasks = await getTasks(date);

    return tasks.length + 1;
  }

  getTasksCount(DateTime date) async {
    var counters = [0, 0, 0, 0, 0];

    List<Task> tasks = await getTasks(date);

    for (var t in tasks) {
      counters[t.type] += 1;

      if (t.closed) {
        counters[4] += 1;
      }
    }

    return counters;
  }
}
