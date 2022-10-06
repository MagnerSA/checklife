import 'package:checklife/services/task.service.dart';
import 'package:checklife/style/style.dart';
import 'package:checklife/widgets/squaredIconButton.dart';
import 'package:checklife/widgets/squaredTextButton.dart';
import 'package:checklife/widgets/taskCard/ageTab.dart';
import 'package:checklife/widgets/taskCard/groupTab.dart';
import 'package:checklife/widgets/taskCard/realocateTab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../controllers/application.controller.dart';
import '../../../../models/task.model.dart';
import '../../../../util/formatting.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final Function deleteTask;
  final Function countTasks;
  final Function setPageState;

  const TaskCard({
    Key? key,
    required this.task,
    required this.deleteTask,
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

  finishTask() async {
    setState(() {
      isLoading = true;
    });

    var newClosed = !widget.task.closed;
    var newClosedAt = "";

    if (newClosed) {
      newClosedAt = formatting.formatDate(app.today);
    }

    await bd
        .collection("users")
        .doc(app.userService.currentUserID())
        .collection("tasks")
        .doc(widget.task.id)
        .update({
      "closedAt": newClosedAt,
      "closed": newClosed,
    });

    setState(() {
      widget.task.closed = newClosed;
      widget.task.closedAt = newClosedAt;
      widget.countTasks();
      isLoading = false;
    });
  }

  deleteTask() async {
    setState(() {
      isLoading = true;
    });

    await widget.deleteTask();

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

  topCard() {
    return Container(
      color: Colors.white,
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
              : Expanded(
                  flex: 1,
                  child: isLoading
                      ? SpinKitRing(
                          color: widget.task.closed
                              ? secondaryColor
                              : Colors.grey.shade400,
                          lineWidth: 2,
                          size: 15,
                        )
                      : IconButton(
                          onPressed: finishTask,
                          icon: Icon(
                            widget.task.closed
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 25,
                            color: widget.task.closed
                                ? secondaryColor
                                : Colors.grey.shade400,
                          ),
                        ),
                ),
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
                        text: widget.task.title,
                        onTap: enableEdit,
                      ),
              ),
            ),
          ),
          isEditing
              ? SquaredIconButton(
                  iconData: Icons.check,
                  iconSize: 25,
                  width: 50,
                  height: 50,
                  onTap: isModified ? saveChanges : null,
                  iconColor: isModified ? greenColor : Colors.grey[300],
                )
              : Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: setIsOpened,
                    icon: Icon(
                      isOpened
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 25,
                      color: Colors.grey.shade500,
                    ),
                  ),
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

  bottomOptions() {
    return isOpened
        ? Container(
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
                isEditing && !isLoading
                    ? Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: deleteTask,
                          child: Ink(
                            width: 50,
                            child: const Center(
                              child: Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: redColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                Expanded(
                  child: Container(),
                ),
                isEditing && !isLoading
                    ? Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isEditing = false;
                            });
                          },
                          child: Ink(
                              width: 50,
                              child: const Center(
                                child: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: redColor,
                                ),
                              )),
                        ),
                      )
                    : const SizedBox(),
                !isEditing
                    ? Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: enableEdit,
                          child: Ink(
                            width: 50,
                            child: const Center(
                              child: Icon(
                                Icons.edit_outlined,
                                size: 20,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                isModified && isEditing
                    ? Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: saveChanges,
                          child: Ink(
                            width: 50,
                            child: const Center(
                              child: Icon(
                                Icons.check,
                                size: 20,
                                color: greenColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          )
        : Container();
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
                      GroupTab(
                        task: widget.task,
                      ),
                      AgeTab(
                        task: widget.task,
                      ),
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
