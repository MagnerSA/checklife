import 'package:checklife/controllers/application.controller.dart';
import 'package:checklife/models/task.model.dart';
import 'package:checklife/style/style.dart';
import 'package:checklife/widgets/squaredIconButton.dart';
import 'package:checklife/widgets/squaredTextButton.dart';
import 'package:flutter/material.dart';

class TypeTab extends StatefulWidget {
  final Function setStatePage;
  final Task task;

  const TypeTab({
    Key? key,
    required this.setStatePage,
    required this.task,
  }) : super(key: key);

  @override
  State<TypeTab> createState() => _TypeTabState();
}

class _TypeTabState extends State<TypeTab> {
  ApplicationController app = ApplicationController();

  bool isChoosingType = false;

  changeSelection() {
    setState(() {
      isChoosingType = !isChoosingType;
    });
  }

  updateTaskType(int type) {
    widget.setStatePage();
    setState(() {});

    widget.task.type = type;

    app.taskService.updateTask(widget.task);
    widget.setStatePage();

    setState(() {});
  }

  row(int type, {bool? isFirst}) {
    bool isCurrent = widget.task.type == type;

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SquaredIconButton(
        width: 50,
        height: 49,
        iconData: isCurrent ? Icons.circle : Icons.circle_outlined,
        iconSize: 16,
        iconColor: app.types.getColor(type),
        onTap: () {
          updateTaskType(type);
        },
      ),
      SquaredTextButton(
        height: 49,
        text: app.types.getTitle(type),
        onTap: isChoosingType
            ? () {
                updateTaskType(type);
              }
            : changeSelection,
        textColor: isCurrent ? Colors.black : Colors.grey[400],
      ),
      isFirst ?? false
          ? SquaredIconButton(
              iconData: isChoosingType
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              iconColor: Colors.grey[500],
              height: 49,
              width: 50,
              onTap: changeSelection,
            )
          : const SizedBox(
              width: 50,
              height: 50,
            )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return app.realocatedTask != null
        ? const SizedBox()
        : AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: isChoosingType ? 200 : 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            child: Column(
              children: [
                ...(isChoosingType
                    ? [
                        row(0, isFirst: true),
                        row(1),
                        row(2),
                        row(3),
                      ]
                    : [
                        row(widget.task.type, isFirst: true),
                      ])
              ],
            ),
          );
  }
}
