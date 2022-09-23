import 'package:checklife/controllers/application.controller.dart';
import 'package:checklife/services/task.service.dart';
import 'package:checklife/style/style.dart';
import 'package:checklife/util/comparing.dart';
import 'package:checklife/view/calendarPage.dart';
import 'package:checklife/util/formatting.dart';
import 'package:checklife/models/task.model.dart';
import 'package:checklife/view/dayPage/widgets/taskCard.dart';
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
  TaskService service = TaskService();
  Comparing compare = Comparing();
  Formatting formatting = Formatting();
  ApplicationController app = ApplicationController();
  FirebaseFirestore bd = FirebaseFirestore.instance;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  bool isLoading = true;
  bool filter = false;

  List<Task> tasks = [];

  @override
  initState() {
    loadTasks();
    super.initState();
  }

  loadTasks() async {
    isLoading = true;

    tasks.clear();

    tasks = await service.getTasks(app.currentDate);

    DateTime lastUpdate = await service.getLastUpdate();

    if (lastUpdate.isBefore(app.currentDate) &&
        compare.isSameDay(app.today, app.currentDate)) {
      getOldTasks(lastUpdate);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  getNextIndex() {
    int nextIndex = 1;

    if (tasks.isNotEmpty) {
      nextIndex = formatting.getIndex(tasks[tasks.length - 1]) + 1;
    }

    return nextIndex;
  }

  getOldTasks(DateTime lastUpdate) async {
    var nextIndex = getNextIndex();

    var date = lastUpdate;

    while (compare.isBeforeToday(date)) {
      List<Task> list = await service.getPendentTasks(date);
      for (var task in list) {
        service.createTask(task, app.currentDate, nextIndex);
        service.deleteTask(task.id);
        nextIndex++;
      }
      date = date.add(const Duration(days: 1));
    }

    await service.setLastUpdate(app.currentDate);

    loadTasks();
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
    Task newTask = Task(
      date: "",
      title: controller.text,
      id: "",
      closed: false,
      description: "",
      createdAt: formatting.formatDate(app.today),
    );

    newTask =
        await service.createTask(newTask, app.currentDate, getNextIndex());
    tasks.add(newTask);

    setState(() {
      controller.clear();
    });
  }

  setFilter() {
    setState(() {
      filter = !filter;
    });
  }

  // focusNode.requestFocus();

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
                      child: IconButton(
                        onPressed: setFilter,
                        icon: Icon(
                          filter
                              ? Icons.filter_alt_off_outlined
                              : Icons.filter_alt_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
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
                      child: const SpinKitDoubleBounce(
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
                      card = Visibility(
                        visible: !compare.isBeforeToday(app.currentDate) &&
                            !isLoading,
                        child: Column(
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
                                        focusNode: focusNode,
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
                        ),
                      );
                    } else {
                      Task element = tasks.elementAt(i);
                      card = Visibility(
                        visible: (compare.isBeforeToday(app.currentDate)) ||
                            (!filter || !element.closed),
                        child: Column(
                          children: [
                            TaskCard(
                              deleteTask: () async {
                                await service.deleteTask(element.id);
                                setState(() {
                                  tasks.removeAt(i);
                                });
                              },
                              task: element,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
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
