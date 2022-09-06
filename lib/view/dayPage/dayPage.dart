import 'package:checklife/controllers/application.controller.dart';
import 'package:checklife/style/style.dart';
import 'package:checklife/view/calendarPage.dart';
import 'package:checklife/util/formatting.dart';
import 'package:checklife/models/task.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../mock/tasks.dart';

class DayPage extends StatefulWidget {
  const DayPage({Key? key}) : super(key: key);

  @override
  State<DayPage> createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  Formatting formatting = Formatting();
  ApplicationController app = ApplicationController();
  FirebaseFirestore bd = FirebaseFirestore.instance;
  TextEditingController controller = TextEditingController();
  bool isLoading = true;

  List<Task> tasks = [];

  @override
  initState() {
    // updateTasks();
    loadTasks();
    super.initState();
  }

  loadTasks() async {
    tasks.clear();

    isLoading = true;

    var collection = await bd
        .collection("tasks")
        .where("date", isEqualTo: formatting.formatDate(app.currentDate))
        .get();

    setState(() {
      for (var doc in collection.docs) {
        Task task = Task.fromMap(doc.data());
        tasks.add(task);
      }
      isLoading = false;
    });
  }

  navigateToCalendar() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const CalendarPage()),
      (Route<dynamic> route) => false,
    );
  }

  navigateToTomorrow() {
    DateTime tomorrow = app.currentDate.add(const Duration(days: 1));

    setState(() {
      app.setCurrentDate(tomorrow);
      loadTasks();
    });
  }

  navigateToYesterday() {
    DateTime yesterday = app.currentDate.subtract(const Duration(days: 1));

    setState(() {
      app.setCurrentDate(yesterday);
      loadTasks();
    });
  }

  createTask() async {
    String taskCode = (tasks.length + 1).toString().padLeft(5, '0');
    String taskDate = formatting.formatDate(app.currentDate);

    String id = "$taskDate $taskCode";

    Task newTask = Task(
      date: taskDate,
      title: controller.text,
      id: id,
      closed: false,
      description: "",
    );

    await bd
        .collection("tasks")
        .doc("$taskDate $taskCode")
        .set(newTask.toMap());

    setState(() {
      controller.clear();
      loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            children: [
              Container(
                color: primaryColor,
                height: 75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "${formatting.getWeekDay(app.currentDate)}, ${formatting.dayAndMonth(app.currentDate)}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: Text(
                              formatting
                                  .getRelativeDayDescription(app.currentDate),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: navigateToCalendar,
                        icon: const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isLoading,
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const SizedBox(
                      height: 100,
                      child: const SpinKitFoldingCube(
                        color: secondaryColor,
                        size: 50,
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Carregando...",
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: tasks.length + 1,
                  itemBuilder: (context, i) {
                    Widget card;

                    if (i == tasks.length) {
                      card = Column(
                        children: [
                          Container(
                            color: Colors.white,
                            height: 35,
                            width: 350,
                            child: Center(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: controller,
                                      decoration: const InputDecoration(
                                        hintText: "Criar nova tarefa",
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: createTask,
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    } else {
                      Task element = tasks.elementAt(i);
                      card = Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            height: 35,
                            width: 350,
                            child: Center(child: Text(element.title)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    }
                    return card;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container()),
                  IconButton(
                    onPressed: navigateToYesterday,
                    icon: const Icon(Icons.keyboard_arrow_left),
                  ),
                  Expanded(child: Container()),
                  IconButton(
                    onPressed: navigateToTomorrow,
                    icon: const Icon(Icons.keyboard_arrow_right),
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
