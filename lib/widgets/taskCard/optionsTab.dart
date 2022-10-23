import 'package:checklife/controllers/application.controller.dart';
import 'package:checklife/models/task.model.dart';
import 'package:checklife/style/style.dart';
import 'package:checklife/widgets/squaredIconButton.dart';
import 'package:checklife/widgets/squaredTextButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OptionsTab extends StatefulWidget {
  final Task task;
  final Function changeSelectedTab;
  final int selectedTab;
  const OptionsTab({
    Key? key,
    required this.task,
    required this.changeSelectedTab,
    required this.selectedTab,
  }) : super(key: key);

  @override
  State<OptionsTab> createState() => _OptionsTabState();
}

class _OptionsTabState extends State<OptionsTab> {
  ApplicationController app = ApplicationController();
  FirebaseFirestore bd = FirebaseFirestore.instance;

  TextEditingController textController = TextEditingController();

  bool isEditing = false;
  bool isModified = false;
  bool isLoading = false;

  enableEdit() {
    setState(() {
      isEditing = true;
      textController.text = widget.task.description ?? "";
    });
  }

  saveChanges() async {
    setState(() {
      isEditing = false;
      isModified = false;
      isLoading = true;
    });

    widget.task.description = textController.text;
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

  getAge() {
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
        : "${widget.task.closed ? "Durou" : "Idade"}\n $age dia${age == 1 ? "" : "s"}";

    return age == 0
        ? (widget.task.closed
            ? "Finalizada ${app.compare.isSameDay(app.today, DateTime.parse(widget.task.closedAt)) ? "hoje" : "no mesmo dia"}"
            : "Criada hoje")
        : text;
    ;
  }

  _optionIcon({
    IconData? icon,
    String? text,
    double? iconSize,
    int? number,
    Color? iconColor,
  }) {
    return Expanded(
      flex: 3,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            widget.changeSelectedTab(number);
          },
          child: Ink(
            height: 65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox()),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Icon(
                      icon,
                      size: iconSize,
                      color: iconColor ??
                          (widget.selectedTab == number
                              ? primaryColor
                              : greyColor),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    text ?? "",
                    style: TextStyle(
                      color: (widget.selectedTab == number
                          ? (iconColor ?? primaryColor)
                          : greyColor),
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50,
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
          const Expanded(flex: 1, child: SizedBox()),
          _optionIcon(
            icon: Icons.edit_calendar,
            text: "Realocação",
            number: 0,
          ),
          _optionIcon(
            icon:
                widget.selectedTab == 1 ? Icons.circle : Icons.circle_outlined,
            text: "Tipo",
            iconSize: 20,
            number: 1,
            iconColor: app.types.getColor(widget.task.type),
          ),
          _optionIcon(
            icon: Icons.event,
            text: "Prazo",
            number: 2,
          ),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}
