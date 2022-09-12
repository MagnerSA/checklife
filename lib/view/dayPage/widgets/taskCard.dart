import 'package:checklife/services/task.service.dart';
import 'package:checklife/style/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../controllers/application.controller.dart';
import '../../../models/task.model.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final Function deleteTask;

  const TaskCard({Key? key, required this.task, required this.deleteTask})
      : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  ApplicationController app = ApplicationController();
  bool isLoading = false;
  FirebaseFirestore bd = FirebaseFirestore.instance;
  TaskService service = TaskService();
  bool isOpened = false;

  finishTask() async {
    setState(() {
      isLoading = true;
    });

    print("ID aqui ${widget.task.id}");
    print("TASK: ${widget.task.toString()}");

    widget.task.closed = !widget.task.closed;
    await bd.collection("tasks").doc(widget.task.id).set(widget.task.toMap());

    setState(() {
      isLoading = false;
    });
  }

  deleteTask() async {
    setState(() {
      isLoading = true;
    });

    await widget.deleteTask();

    setState(() {
      isLoading = false;
    });
  }

  setIsOpened() {
    setState(() {
      isOpened = !isOpened;
    });
  }

  topCard() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
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
              child: Center(child: Text(widget.task.title)),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: setIsOpened,
              icon: Icon(
                isOpened ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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
    if (widget.task.createdAt != "") {
      DateTime createdAt = DateTime.parse(widget.task.createdAt);
      print("HOJE ${app.currentDate}");
      print("DIA $createdAt");
      age = createdAt.compareTo(app.today) < 0
          ? app.currentDate.difference(createdAt).inDays
          : 0;
      print("DIFERENÇA ${age}");
    }

    String text = age == -1 ? "Indisponível" : "Idade: $age dias";

    return !isOpened
        ? Container()
        : Container(
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
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 5,
                  child: Center(child: Text(age == 0 ? "" : text)),
                ),
                Expanded(
                  flex: 1,
                  child: isLoading
                      ? const SpinKitRing(
                          color: redColor,
                          lineWidth: 2,
                          size: 15,
                        )
                      : IconButton(
                          onPressed: deleteTask,
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 25,
                            color: redColor,
                          ),
                        ),
                ),
              ],
            ),
          );
  }

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
              bottomCard(),
            ],
          ),
        ),
      ],
    );
  }
}
