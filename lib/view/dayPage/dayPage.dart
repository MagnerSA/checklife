import 'dart:async';

import 'package:checklife/controllers/application.controller.dart';
import 'package:checklife/services/task.service.dart';
import 'package:checklife/style/style.dart';
import 'package:checklife/util/comparing.dart';
import 'package:checklife/util/types.dart';
import 'package:checklife/view/calendarPage/calendarPage.dart';
import 'package:checklife/util/formatting.dart';
import 'package:checklife/models/task.model.dart';
import 'package:checklife/view/dayPage/widgets/optionsFooter.dart';
import 'package:checklife/view/dayPage/widgets/realocatingTask.dart';
import 'package:checklife/view/dayPage/widgets/taskCounter.dart';
import 'package:checklife/view/dayPage/widgets/taskCreationCard.dart';
import 'package:checklife/view/dayPage/widgets/topBar.dart';
import 'package:checklife/widgets/taskCard/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../login/login.dart';

class DayPage extends StatefulWidget {
  const DayPage({Key? key}) : super(key: key);

  @override
  State<DayPage> createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  ApplicationController app = ApplicationController();
  TaskService service = TaskService();

  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();
  FocusNode focusNode = FocusNode();

  bool isLoading = true;
  bool isFiltering = false;

  Map<int, bool> filters = {
    Types.simple: true,
    Types.closed: true,
    Types.urgent: true,
    Types.futile: true,
    Types.reminder: true,
  };

  List<Task> tasks = [];
  List<int> tasksCounter = [0, 0, 0, 0, 0];

  @override
  initState() {
    loadTasks();
    super.initState();
  }

  loadTasks() async {
    setState(() {
      isLoading = true;
      tasks.clear();
    });

    tasks = await service.getTasks(app.currentDate);

    String lastUpdateString = await service.getLastUpdate();
    if (lastUpdateString == "") {
      await service.setLastUpdate(app.currentDate);

      lastUpdateString = app.formatting.formatDate(app.today);
    }

    DateTime lastUpdate = DateTime.parse(lastUpdateString);

    if (lastUpdate.isBefore(app.currentDate) &&
        app.compare.isSameDay(app.today, app.currentDate)) {
      getOldTasks(lastUpdate);
    } else {
      setState(() {
        countTasks();
        isLoading = false;
      });
    }
  }

  countTasks() {
    tasksCounter = [0, 0, 0, 0, 0];

    for (var element in tasks) {
      if (element.closed) {
        tasksCounter[Types.closed]++;
      } else {
        tasksCounter[element.type]++;
      }
    }

    setState(() {});
  }

  _getNextIndex() {
    int nextIndex = 1;

    if (tasks.isNotEmpty) {
      nextIndex = app.formatting.getIndex(tasks[tasks.length - 1]) + 1;
    }

    return nextIndex;
  }

  getOldTasks(DateTime lastUpdate) async {
    var date = lastUpdate;

    while (app.compare.isBeforeToday(date)) {
      List<Task> list = await service.getPendentTasks(date);
      for (var task in list) {
        await service.createTask(task, app.currentDate);
        await service.deleteTask(task.id);
      }
      date = date.add(const Duration(days: 1));
    }

    await service.setLastUpdate(app.currentDate);

    loadTasks();
  }

  _navigateToCalendar() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const CalendarPage()),
      (Route<dynamic> route) => false,
    );
  }

  _navigateToToday() {
    setState(() {
      app.setCurrentDate(app.today);
      loadTasks();
    });
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
      title: textController.text,
      id: "",
      closed: false,
      description: "",
      closedAt: "",
      createdAt: app.formatting.formatDate(app.today),
      type: 0,
    );

    newTask = await service.createTask(newTask, app.currentDate);
    tasks.add(newTask);

    setState(() {
      countTasks();
      textController.clear();
    });
  }

  void addNewTask(Task newTask) {
    tasks.add(newTask);
  }

  setFilter() {
    setState(() {
      isFiltering = !isFiltering;
    });
  }

  _removeTask(int i) {
    setState(() {
      tasks.removeAt(i);
      countTasks();
    });
  }

  _deleteTask(Task element, int i) async {
    await service.deleteTask(element.id);
    _removeTask(i);
  }

  _showTask(Task element) {
    bool simpleFilter = (filters[element.type] ?? true);

    if (element.closed) {
      simpleFilter = filters[1] ?? false;
    }

    return simpleFilter;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            children: [
              TopBar(
                isFiltering: isFiltering,
                setPageState: () {
                  setState(() {});
                },
                setFilter: setFilter,
                navigateToToday: _navigateToToday,
              ),
              TaskCounter(
                setPageState: () {
                  setState(() {});
                },
                reloadTasks: () {
                  loadTasks();
                },
                isLoadingTasks: isLoading,
                filters: filters,
                allTasksCount: tasks.length,
                urgentTasksCount: tasksCounter[Types.urgent],
                regularTasksCount: tasksCounter[Types.simple],
                reminderTasksCount: tasksCounter[Types.reminder],
                futileTasksCount: tasksCounter[Types.futile],
                closedTasksCount: tasksCounter[Types.closed],
              ),
              Visibility(
                visible: isLoading,
                child: Column(
                  children: const [
                    SizedBox(height: 50),
                    SizedBox(
                      height: 100,
                      child: SpinKitDoubleBounce(
                        color: secondaryColor,
                        size: 50,
                      ),
                    ),
                    Center(
                      child: Text(
                        "Carregando...",
                        style: TextStyle(
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
                  controller: scrollController,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  itemCount: tasks.length + 1,
                  itemBuilder: (context, i) {
                    Widget card;

                    if (i == tasks.length) {
                      card = Visibility(
                        visible: !app.compare.isBeforeToday(app.currentDate) &&
                            !isLoading,
                        child: TaskCreationCard(
                          focusNode: focusNode,
                          createTask: createTask,
                          textController: textController,
                        ),
                      );
                    } else {
                      Task element = tasks.elementAt(i);
                      card = Visibility(
                        visible: _showTask(element),
                        child: Column(
                          children: [
                            TaskCard(
                                removeTask: () {
                                  _removeTask(i);
                                },
                                task: element,
                                countTasks: countTasks,
                                setPageState: () {
                                  setState(() {});
                                }),
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
              app.realocatedTask == null
                  ? const SizedBox()
                  : RealocatingTask(
                      addNewTask: addNewTask,
                      setPageState: () {
                        setState(() {});
                      },
                    ),
              OptionsFooter(
                navigateToYesterday: navigateToYesterday,
                navigateToTomorrow: navigateToTomorrow,
                scrollController: scrollController,
                focusNode: focusNode,
              )
            ],
          ),
        ),
      ),
    );
  }
}
