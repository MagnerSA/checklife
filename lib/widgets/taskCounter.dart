import 'package:checklife/style/style.dart';
import 'package:checklife/util/types.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../controllers/application.controller.dart';

class TaskCounter extends StatefulWidget {
  final int urgentTasksCount;
  final int regularTasksCount;
  final int reminderTasksCount;
  final int futileTasksCount;
  final int closedTasksCount;

  const TaskCounter({
    Key? key,
    required this.closedTasksCount,
    required this.regularTasksCount,
    required this.urgentTasksCount,
    required this.reminderTasksCount,
    required this.futileTasksCount,
  }) : super(key: key);

  @override
  State<TaskCounter> createState() => _TaskCounterState();
}

class _TaskCounterState extends State<TaskCounter> {
  ApplicationController app = ApplicationController();
  FirebaseFirestore bd = FirebaseFirestore.instance;

  TextEditingController textController = TextEditingController();

  bool isLoading = false;
  bool isOpened = false;
  bool isEditing = false;
  bool isModified = false;

  counterIcon({count, color}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            count.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        // height: 40,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.urgentTasksCount == 0
                ? const SizedBox()
                : counterIcon(
                    count: widget.urgentTasksCount,
                    color: app.types.getColor(Types.urgent),
                  ),
            widget.regularTasksCount == 0
                ? const SizedBox()
                : counterIcon(
                    count: widget.regularTasksCount,
                    color: app.types.getColor(Types.simple),
                  ),
            widget.reminderTasksCount == 0
                ? const SizedBox()
                : counterIcon(
                    count: widget.reminderTasksCount,
                    color: app.types.getColor(Types.reminder),
                  ),
            widget.futileTasksCount == 0
                ? const SizedBox()
                : counterIcon(
                    count: widget.futileTasksCount,
                    color: app.types.getColor(Types.futile),
                  ),
            widget.closedTasksCount == 0
                ? const SizedBox()
                : counterIcon(
                    count: widget.closedTasksCount,
                    color: greenColor,
                  ),
          ],
        ),
      ),
    );
  }
}
