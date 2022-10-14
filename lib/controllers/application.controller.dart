import 'package:checklife/controllers/navigation.controller.dart';
import 'package:checklife/services/task.service.dart';
import 'package:checklife/services/user.service.dart';
import 'package:checklife/util/comparing.dart';
import 'package:checklife/util/formatting.dart';
import 'package:checklife/util/types.dart';

import '../models/task.model.dart';

class ApplicationController {
  DateTime now = DateTime.now()
      .subtract(const Duration(hours: 3))
      .add(const Duration(days: 0));
  late DateTime today = DateTime(now.year, now.month, now.day);
  late DateTime currentDate = DateTime(now.year, now.month, now.day);

  Task? realocatedTask;

  static final ApplicationController _applicationController =
      ApplicationController._internal();

  factory ApplicationController() {
    return _applicationController;
  }

  ApplicationController._internal();

  Comparing compare = Comparing();
  Formatting formatting = Formatting();
  TaskService taskService = TaskService();
  UserService userService = UserService();
  NavigationController navigate = NavigationController();
  Types types = Types();

  setCurrentDate(DateTime newDate) {
    currentDate = DateTime(newDate.year, newDate.month, newDate.day);
  }

  setRealocatedTask(Task task) {
    realocatedTask = task;
  }

  clearRealocation() {
    realocatedTask = null;
  }
}
