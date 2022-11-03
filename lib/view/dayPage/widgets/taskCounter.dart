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
  final int allTasksCount;
  final Function setPageState;
  final Map<int, bool> filters;
  final void Function() reloadTasks;
  final bool isLoadingTasks;

  const TaskCounter({
    Key? key,
    required this.closedTasksCount,
    required this.regularTasksCount,
    required this.urgentTasksCount,
    required this.reminderTasksCount,
    required this.futileTasksCount,
    required this.allTasksCount,
    required this.setPageState,
    required this.filters,
    required this.reloadTasks,
    required this.isLoadingTasks,
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

  counterIcon({count, color, type}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: type == -1
            ? () {
                widget.filters[Types.simple] = true;
                widget.filters[Types.closed] = true;
                widget.filters[Types.urgent] = true;
                widget.filters[Types.futile] = true;
                widget.filters[Types.reminder] = true;
                widget.setPageState();
              }
            : () {
                bool oldFilter = widget.filters[type] ?? false;
                widget.filters[type] = !oldFilter;
                widget.setPageState();
              },
        borderRadius: BorderRadius.circular(50),
        child: Ink(
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
                    color: (widget.filters[Types.urgent] ?? false)
                        ? app.types.getColor(Types.urgent)
                        : app.types.getDarkColor(Types.urgent),
                    type: Types.urgent,
                  ),
            widget.regularTasksCount == 0
                ? const SizedBox()
                : counterIcon(
                    count: widget.regularTasksCount,
                    color: (widget.filters[Types.simple] ?? false)
                        ? app.types.getColor(Types.simple)
                        : app.types.getDarkColor(Types.simple),
                    type: Types.simple,
                  ),
            widget.reminderTasksCount == 0
                ? const SizedBox()
                : counterIcon(
                    count: widget.reminderTasksCount,
                    color: (widget.filters[Types.reminder] ?? false)
                        ? app.types.getColor(Types.reminder)
                        : app.types.getDarkColor(Types.reminder),
                    type: Types.reminder,
                  ),
            widget.futileTasksCount == 0
                ? const SizedBox()
                : counterIcon(
                    count: widget.futileTasksCount,
                    color: (widget.filters[Types.futile] ?? false)
                        ? app.types.getColor(Types.futile)
                        : app.types.getDarkColor(Types.futile),
                    type: Types.futile,
                  ),
            widget.closedTasksCount == 0
                ? const SizedBox()
                : counterIcon(
                    count: widget.closedTasksCount,
                    color: (widget.filters[Types.closed] ?? false)
                        ? app.types.getColor(Types.closed)
                        : app.types.getDarkColor(Types.closed),
                    type: Types.closed,
                  ),
            const SizedBox(width: 20),
            widget.allTasksCount == 0
                ? const SizedBox()
                : counterIcon(
                    count: widget.allTasksCount,
                    color: Colors.grey.shade400,
                    type: -1,
                  ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: InkWell(
                onTap: widget.reloadTasks,
                borderRadius: BorderRadius.circular(50),
                child: Ink(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color:
                        widget.isLoadingTasks ? primaryColor : secondaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Icon(
                      widget.isLoadingTasks ? Icons.more_horiz : Icons.refresh,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
