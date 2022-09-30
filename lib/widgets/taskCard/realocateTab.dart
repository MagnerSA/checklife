import 'package:checklife/controllers/application.controller.dart';
import 'package:checklife/models/task.model.dart';
import 'package:checklife/style/style.dart';
import 'package:flutter/material.dart';

class RealocateTab extends StatefulWidget {
  final Function setStatePage;
  final Task task;

  const RealocateTab({
    Key? key,
    required this.setStatePage,
    required this.task,
  }) : super(key: key);

  @override
  State<RealocateTab> createState() => _RealocateTabState();
}

class _RealocateTabState extends State<RealocateTab> {
  ApplicationController app = ApplicationController();

  bool isShowingOptions = false;
  bool isRealocating = false;

  setRealocatedDay() {
    app.setRealocatedTask(widget.task);
    print(app.realocatedTask);
    setState(() {});
    widget.setStatePage();
  }

  @override
  Widget build(BuildContext context) {
    return app.realocatedTask != null
        ? const SizedBox()
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
                isShowingOptions
                    ? const SizedBox()
                    : Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isShowingOptions = true;
                            });
                          },
                          child: Ink(
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "Realocar",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                !isShowingOptions
                    ? const SizedBox()
                    : Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            setRealocatedDay();
                          },
                          child: Ink(
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "Escolher dia",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                true
                    ? const SizedBox()
                    : Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isShowingOptions = isShowingOptions;
                            });
                          },
                          child: Ink(
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "Por número de dias",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                !isShowingOptions
                    ? const SizedBox()
                    : Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isShowingOptions = false;
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
                            ),
                          ),
                        ),
                      )
              ],
            ),
          );
  }
}
