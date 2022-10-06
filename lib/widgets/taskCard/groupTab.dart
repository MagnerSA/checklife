import 'package:checklife/controllers/application.controller.dart';
import 'package:checklife/models/task.model.dart';
import 'package:checklife/widgets/squaredTextButton.dart';
import 'package:flutter/material.dart';

class GroupTab extends StatefulWidget {
  final Task task;
  const GroupTab({Key? key, required this.task}) : super(key: key);

  @override
  State<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab> {
  ApplicationController app = ApplicationController();

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
            onTap: () {},
          ),
          SquaredTextButton(
            text: "Adicionar em Grupo",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return bottomCard();
  }
}
