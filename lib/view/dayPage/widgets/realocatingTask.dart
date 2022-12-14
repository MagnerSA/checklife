import 'package:checklife/controllers/application.controller.dart';
import 'package:checklife/style/style.dart';
import 'package:checklife/widgets/squaredIconButton.dart';
import 'package:checklife/widgets/squaredTextButton.dart';
import 'package:flutter/material.dart';

import '../../../models/task.model.dart';

class RealocatingTask extends StatefulWidget {
  final void Function() setPageState;
  final void Function(Task) addNewTask;

  const RealocatingTask({
    Key? key,
    required this.setPageState,
    required this.addNewTask,
  }) : super(key: key);

  @override
  State<RealocatingTask> createState() => _RealocatingTaskState();
}

class _RealocatingTaskState extends State<RealocatingTask> {
  ApplicationController app = ApplicationController();

  Task fakeTask = Task(
    closed: false,
    closedAt: '',
    createdAt: '',
    date: '',
    id: '',
    title: '',
    type: 0,
    groupID: "",
    groupStatus: "",
  );

  getRealocationText() {
    String realocationText = "";

    DateTime taskDate = DateTime.parse((app.realocatedTask ?? fakeTask).date);

    if (app.compare.isSameDay(app.currentDate, taskDate)) {
      realocationText = "Impossível realocar para o mesmo dia";
    } else if (app.compare.isBeforeToday(app.currentDate)) {
      realocationText = "Impossível realocar para o passado";
    } else {
      realocationText = "Realocar";
    }

    return realocationText;
  }

  isRealocationValid() {
    bool isValid = false;

    DateTime taskDate = DateTime.parse((app.realocatedTask ?? fakeTask).date);

    if (!app.compare.isSameDay(app.currentDate, taskDate) &&
        !app.compare.isBeforeToday(app.currentDate)) {
      isValid = true;
    }

    return isValid;
  }

  realocateTask() async {
    Task fakeTask = Task(
      type: 0,
      closed: false,
      closedAt: '',
      createdAt: '',
      date: '',
      id: '',
      title: '',
      groupID: "",
      groupStatus: "",
    );

    Task newTask = await app.taskService.realocateTask(
      app.realocatedTask ?? fakeTask,
      app.currentDate,
    );

    widget.addNewTask(newTask);
    app.clearRealocation();
    widget.setPageState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Container(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "Realocando:",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  SquaredIconButton(
                    onTap: () {
                      widget.setPageState();
                      setState(() {
                        app.clearRealocation();
                      });
                    },
                    iconData: Icons.close,
                    iconSize: 15,
                    iconColor: redColor,
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const SizedBox(
                  //   height: 50,
                  //   width: 50,
                  // ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                        left: 10,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade300,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 12,
                                color: app.realocatedTask == null
                                    ? Colors.grey
                                    : app.types
                                        .getColor(app.realocatedTask!.type),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                app.realocatedTask == null
                                    ? ""
                                    : app.realocatedTask?.title ?? "",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: SquaredTextButton(
                        height: 50,
                        textColor: isRealocationValid() ? blueColor : redColor,
                        text: getRealocationText(),
                        onTap: isRealocationValid() ? realocateTask : null,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
