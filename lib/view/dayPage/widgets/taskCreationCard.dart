import 'package:checklife/services/task.service.dart';
import 'package:checklife/style/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../controllers/application.controller.dart';
import '../../../models/task.model.dart';
import '../../../util/formatting.dart';

class TaskCreationCard extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController textController;
  final void Function() createTask;

  const TaskCreationCard({
    Key? key,
    required this.focusNode,
    required this.textController,
    required this.createTask,
  }) : super(key: key);

  @override
  State<TaskCreationCard> createState() => _TaskCreationCardState();
}

class _TaskCreationCardState extends State<TaskCreationCard> {
  ApplicationController app = ApplicationController();
  FirebaseFirestore bd = FirebaseFirestore.instance;
  Formatting formatting = Formatting();
  TaskService service = TaskService();

  bool isLoading = false;
  bool isOpened = false;
  bool isEditing = false;
  bool isModified = false;

  _isBeforeToday() {
    return app.compare.isBeforeToday(app.currentDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          // width: 350,
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLines: null,
                    focusNode: widget.focusNode,
                    controller: widget.textController,
                    decoration: const InputDecoration(
                      hintText: "Criar nova tarefa",
                    ),
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),
                ),
                widget.textController.text == ""
                    ? const SizedBox()
                    : IconButton(
                        onPressed: widget.createTask,
                        icon: const Icon(Icons.add),
                      ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
