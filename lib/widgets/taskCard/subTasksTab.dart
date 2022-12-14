import 'package:checklife/controllers/application.controller.dart';
import 'package:checklife/models/task.model.dart';
import 'package:checklife/widgets/squaredTextButton.dart';
import 'package:flutter/material.dart';

import '../../view/dayPage/widgets/taskCreationCard.dart';

class SubTasksTab extends StatefulWidget {
  final Task task;
  final Function setPageState;

  const SubTasksTab({
    Key? key,
    required this.task,
    required this.setPageState,
  }) : super(key: key);

  @override
  State<SubTasksTab> createState() => _SubTasksTabState();
}

class _SubTasksTabState extends State<SubTasksTab> {
  ApplicationController app = ApplicationController();

  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();

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

      print("AQUI");
      print(createdAt);
      print(closedAt);
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

    turnIntoGroup() {
      widget.task.groupStatus = "group";
      app.taskService.turnIntoGroup(widget.task);

      setState(() {
        widget.task.groupStatus = "group";
        widget.setPageState();
      });
    }

    return Container(
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
          SquaredTextButton(
            text: "Transformar em Grupo",
            onTap: turnIntoGroup,
          ),
          // SquaredTextButton(
          //   text: "Adicionar em Grupo",
          //   onTap: () {},
          // ),
        ],
      ),
    );
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
      groupStatus: "subtask",
      groupID: widget.task.id,
    );

    newTask = await app.taskService
        .createSubTask(newTask, app.currentDate, widget.task.groupID);
    // tasks.add(newTask);

    setState(() {
      // countTasks();
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TaskCreationCard(
          focusNode: focusNode,
          createTask: createTask,
          textController: textController,
          text: "Criar subtarefa",
        )
      ],
    );
  }
}
