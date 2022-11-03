import 'package:checklife/controllers/application.controller.dart';
import 'package:checklife/models/task.model.dart';
import 'package:checklife/style/style.dart';
import 'package:checklife/widgets/squaredIconButton.dart';
import 'package:checklife/widgets/squaredTextButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AgeTab extends StatefulWidget {
  final Task task;
  final void Function() deleteTask;
  const AgeTab({
    Key? key,
    required this.task,
    required this.deleteTask,
  }) : super(key: key);

  @override
  State<AgeTab> createState() => _AgeTabState();
}

class _AgeTabState extends State<AgeTab> {
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
          Expanded(
            flex: 5,
            child: Center(
                child: Text(age == 0
                    ? (widget.task.closed
                        ? "Finalizada ${app.compare.isSameDay(app.today, DateTime.parse(widget.task.closedAt)) ? "hoje" : "no mesmo dia"}"
                        : "Criada hoje")
                    : text)),
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
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
        : "${widget.task.closed ? "Durou\n" : "Idade\n"}: $age dia${age == 1 ? "" : "s"}";

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
          // // Expanded(
          // //   flex: 5,
          // //   child: Center(
          // //     child: Text(age == 0
          // //         ? (widget.task.closed
          // //             ? "Finalizada ${app.compare.isSameDay(app.today, DateTime.parse(widget.task.closedAt)) ? "hoje" : "no mesmo dia"}"
          // //             : "Criada hoje")
          // //         : text),
          // //   ),
          // // ),
          // // Expanded(
          // //   child: Center(
          // //     child: Text(
          // //       widget.task.description == ""
          // //           ? "Adicionar descrição"
          // //           : widget.task.description ?? "",
          // //     ),
          // //   ),
          // // ),

          // SizedBox(
          //   width: isLoading ? 50 : 0,
          //   height: isLoading ? 50 : 0,
          // ),
          // !isEditing && !isLoading
          //     ? SquaredIconButton(
          //         iconData: Icons.delete_outline,
          //         width: 50,
          //         height: 50,
          //         onTap: widget.deleteTask,
          //         iconColor: redColor,
          //       )
          //     : const SizedBox(),
          // isEditing && !isLoading
          //     ? SquaredIconButton(
          //         iconData: Icons.close,
          //         width: 50,
          //         height: 50,
          //         onTap: () {
          //           setState(() {
          //             isEditing = false;
          //           });
          //         },
          //         iconColor: redColor,
          //       )
          //     : const SizedBox(),
          // Expanded(
          //   flex: 5,
          //   child: Padding(
          //     padding: const EdgeInsets.all(10),
          //     child: Center(
          //       child: isEditing
          //           ? TextFormField(
          //               controller: textController,
          //               onChanged: (_) {
          //                 if (!isModified) {
          //                   setState(() {
          //                     isModified = true;
          //                   });
          //                 }
          //               },
          //             )
          //           // : Text(widget.task.title),
          //           : SquaredTextButton(
          //               text: widget.task.description == ""
          //                   ? "Adicionar descrição"
          //                   : widget.task.description,
          //               textColor: widget.task.description == ""
          //                   ? Colors.grey[400]
          //                   : Colors.black,
          //               onTap: enableEdit,
          //             ),
          //     ),
          //   ),
          // ),
          // isEditing
          //     ? SquaredIconButton(
          //         iconData: Icons.check,
          //         iconSize: 25,
          //         width: 50,
          //         height: 50,
          //         onTap: isModified ? saveChanges : () {},
          //         iconColor: isModified ? greenColor : Colors.grey[300],
          //       )
          //     : SizedBox(
          //         width: 50,
          //         height: 50,
          //         child: Center(
          //           child: Text(
          //             getAge(),
          //             textAlign: TextAlign.center,
          //             style: const TextStyle(
          //               fontSize: 10,
          //             ),
          //           ),
          //         ),
          //       )
        ],
      ),
    );
  }
}
