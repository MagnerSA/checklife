import 'package:checklife/formatting.dart';
import 'package:checklife/task.model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final DateTime date;

  const HomePage({Key? key, required this.date}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Formatting formatting = Formatting();

  Map<String, Task> tasks = {
    "001": Task(
      title: "Atividade 01",
    ),
    "002": Task(
      title: "Atividade 02",
    ),
    "003": Task(
      title: "Atividade 03",
    ),
    "004": Task(
      title: "Atividade 04",
    ),
    "005": Task(
      title: "Atividade 05",
    ),
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Container(
                height: 35,
                width: 350,
                child: Center(child: Text(formatting.getWeekDay(widget.date))),
              ),
              Container(
                height: 35,
                width: 350,
                child: Center(
                    child: Text(
                        formatting.getRelativeDayDescription(widget.date))),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: tasks.values.length,
                  itemBuilder: (context, i) {
                    Task element = tasks.values.elementAt(i);

                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.red,
                          height: 35,
                          width: 350,
                          child: Center(child: Text(element.title)),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}