import 'package:checklife/services/task.service.dart';
import 'package:checklife/style/style.dart';
import 'package:checklife/widgets/squaredIconButton.dart';
import 'package:checklife/widgets/squaredTextButton.dart';
import 'package:checklife/widgets/taskCard/descriptionTab.dart';
import 'package:checklife/widgets/taskCard/groupTab.dart';
import 'package:checklife/widgets/taskCard/realocateTab.dart';
import 'package:checklife/widgets/taskCard/typeTab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../controllers/application.controller.dart';
import '../../../../models/task.model.dart';
import '../../../../util/formatting.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final Function removeTask;
  final Function countTasks;
  final Function setPageState;

  const TaskCard({
    Key? key,
    required this.task,
    required this.removeTask,
    required this.countTasks,
    required this.setPageState,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  ApplicationController app = ApplicationController();
  FirebaseFirestore bd = FirebaseFirestore.instance;
  TaskService service = TaskService();
  Formatting formatting = Formatting();

  TextEditingController textController = TextEditingController();

  bool isLoading = false;
  bool isOpened = false;
  bool isEditing = false;
  bool isModified = false;
  bool isRealocating = false;

  enableEdit() {
    setState(() {
      isEditing = true;
      textController.text = widget.task.title;
    });
  }

  isFinishable() {
    return !app.compare.isBeforeToday(app.currentDate);
  }

  finishTask() async {
    setState(() {
      isLoading = true;
    });

    var newClosed = !widget.task.closed;
    var newClosedAt = "";

    if (newClosed) {
      newClosedAt = formatting.formatDate(app.today);
    }

    if (app.compare.isToday(app.currentDate)) {
      await app.taskService.finishTask(widget.task, newClosed, newClosedAt);

      setState(() {
        widget.task.closed = newClosed;
        widget.task.closedAt = newClosedAt;
        widget.countTasks();
        isLoading = false;
      });
    } else {
      widget.task.closed = newClosed;
      widget.task.closedAt = newClosedAt;
      await app.taskService.realocateTask(widget.task, app.today);
      // await app.taskService.finishTask(widget.task, newClosed, newClosedAt);
      await widget.removeTask();
      setState(() {
        widget.countTasks();
        isLoading = false;
      });
    }
  }

  deleteTask() async {
    setState(() {
      isLoading = true;
    });

    await widget.removeTask();
    await app.taskService.deleteTask(widget.task.id);

    setState(() {
      isEditing = false;
      isOpened = false;
      isLoading = false;
    });
  }

  setIsOpened() {
    setState(() {
      isOpened = !isOpened;
    });
  }

  saveChanges() async {
    setState(() {
      isEditing = false;
      isModified = false;
      isLoading = true;
    });

    widget.task.title = textController.text;
    await bd
        .collection("users")
        .doc(app.userService.currentUserID())
        .collection("tasks")
        .doc(widget.task.id)
        .set(widget.task.toMap());

    setState(() {
      isLoading = false;
    });
  }

  getColor() {}

  Color getBackGroundcolor() {
    Color backgroundColor = Colors.white;

    if (widget.task.type == 1) backgroundColor = redColor;
    if (widget.task.closed) backgroundColor = greenColor;

    return backgroundColor;
  }

  getTextColor() {
    Color textColor = Colors.black;

    if (widget.task.closed || widget.task.type == 1) textColor = Colors.white;

    return textColor;
  }

  getIconColor() {
    Color iconColor = Colors.grey.shade500;

    if (widget.task.closed || widget.task.type == 1) iconColor = Colors.white;

    return iconColor;
  }

  topCard() {
    return Container(
      color: getBackGroundcolor(),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isEditing
              ? SquaredIconButton(
                  iconData: Icons.close,
                  width: 50,
                  height: 50,
                  onTap: () {
                    setState(() {
                      isEditing = false;
                    });
                  },
                  iconColor: redColor,
                )
              : isLoading
                  ? SizedBox(
                      width: 50,
                      height: 50,
                      child: SpinKitRing(
                        color: widget.task.closed
                            ? Colors.white
                            : Colors.grey.shade400,
                        lineWidth: 2,
                        size: 20,
                      ),
                    )
                  : SquaredIconButton(
                      iconData: widget.task.closed
                          ? (isFinishable() ? Icons.check_box : Icons.check)
                          : Icons.check_box_outline_blank,
                      iconColor: widget.task.closed
                          ? Colors.white
                          : app.types.getContrastColor(widget.task.type),
                      backgroundColor: widget.task.closed
                          ? greenColor
                          : app.types.getBackgroundColor(widget.task.type),
                      width: 50,
                      height: 50,
                      onTap: isFinishable() ? finishTask : null,
                    ),
          widget.task.closed
              ? Container(
                  color: app.types.getBackgroundColor(widget.task.type),
                  width: 5,
                )
              : const SizedBox(),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: isEditing
                    ? TextFormField(
                        controller: textController,
                        onChanged: (_) {
                          if (!isModified) {
                            setState(() {
                              isModified = true;
                            });
                          }
                        },
                      )
                    // : Text(widget.task.title),
                    : SquaredTextButton(
                        fitText: true,
                        height: 50,
                        text: widget.task.title,
                        onTap: widget.task.closed ? null : enableEdit,
                        textColor: getTextColor(),
                      ),
              ),
            ),
          ),
          SizedBox(width: widget.task.closed ? 5 : 0),
          isEditing
              ? SquaredIconButton(
                  iconData: Icons.check,
                  iconSize: 25,
                  width: 50,
                  height: 50,
                  onTap: isModified ? saveChanges : null,
                  iconColor: isModified ? greenColor : Colors.grey[300],
                )
              : SquaredIconButton(
                  iconData: isOpened
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  iconSize: 25,
                  width: 50,
                  height: 50,
                  onTap: setIsOpened,
                  iconColor: getIconColor(),
                ),
        ],
      ),
    );
  }

  bottomCard() {
    int age = -1;
    if (widget.task.createdAt != "" &&
        widget.task.closedAt != "" &&
        widget.task.closed) {
      DateTime createdAt = DateTime.parse(widget.task.createdAt);

      DateTime closedAt = DateTime.parse(widget.task.closedAt);

      age = createdAt.compareTo(closedAt) < 0
          ? closedAt.difference(createdAt).inDays
          : 0;
    } else if (widget.task.createdAt != "" && !widget.task.closed) {
      DateTime createdAt = DateTime.parse(widget.task.createdAt);

      DateTime today = app.today;

      age = createdAt.compareTo(today) < 0
          ? today.difference(createdAt).inDays
          : 0;
    }

    String text = age == -1
        ? "Indisponível"
        : "${widget.task.closed ? "Durou" : "Idade"}: $age dia${age == 1 ? "" : "s"}";

    return !isOpened
        ? Container()
        : Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: Center(
                      child: Text(age == 0
                          ? (widget.task.closed
                              ? "Finalizada hoje"
                              : "Criada hoje")
                          : text)),
                ),
              ],
            ),
          );
  }

  realocate() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              topCard(),
              ...(isOpened
                  ? [
                      DescriptionTab(
                        task: widget.task,
                        deleteTask: () {
                          deleteTask();
                        },
                      ),
                      TypeTab(
                        setStatePage: widget.setPageState,
                        task: widget.task,
                        countTasks: widget.countTasks,
                      ),
                      // GroupTab(
                      //   task: widget.task,
                      // ),
                      RealocateTab(
                        setStatePage: widget.setPageState,
                        task: widget.task,
                      )
                    ]
                  : []),
              // bottomOptions(),
            ],
          ),
        ),
      ],
    );
  }
}
