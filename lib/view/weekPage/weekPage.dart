import 'package:checklife/controllers/application.controller.dart';
import 'package:checklife/util/comparing.dart';
import 'package:checklife/util/formatting.dart';
import 'package:checklife/style/style.dart';
import 'package:checklife/widgets/dayCard/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../controllers/application.controller.dart';
import '../dayPage/dayPage.dart';

class WeekPage extends StatefulWidget {
  const WeekPage({Key? key}) : super(key: key);

  @override
  State<WeekPage> createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> {
  Formatting formatting = Formatting();
  Comparing compare = Comparing();
  ApplicationController app = ApplicationController();

  List<List<DateTime>> dates = [];
  int head = 0;
  int lastIndex = 5;

  @override
  initState() {
    initMap();

    super.initState();
  }

  calendarLine(int week) {
    return Expanded(
      child: Row(
        children: [
          DayCard(date: dates[week][0]),
          const SizedBox(width: 2),
          DayCard(date: dates[week][1]),
          const SizedBox(width: 2),
          DayCard(date: dates[week][2]),
          const SizedBox(width: 2),
          DayCard(date: dates[week][3]),
          const SizedBox(width: 2),
          DayCard(date: dates[week][4]),
          const SizedBox(width: 2),
          DayCard(date: dates[week][5]),
          const SizedBox(width: 2),
          DayCard(date: dates[week][6]),
        ],
      ),
    );
  }

  initMap() {
    DateTime lastWeek =
        DateTime.now().subtract(const Duration(hours: 3, days: 7));

    DateTime firstDay =
        lastWeek.subtract(Duration(days: formatting.weekDay(lastWeek) - 1));

    for (int i = 0; i < 6; i++) {
      List<DateTime> week = [];
      for (int j = 0; j < 7; j++) {
        week.add(firstDay.add(Duration(days: (i * 7) + j)));
      }
      dates.add(week);
    }
  }

  goUp() {
    if (head == 0) {
      var lastWeekFirstDay = dates[0][0].subtract(const Duration(days: 7));
      var newWeek = createWeek(lastWeekFirstDay);
      setState(() {
        dates.insert(0, newWeek);
        lastIndex++;
      });
    } else if (head > 0) {
      setState(() {
        head--;
      });
    }
  }

  goDown() {
    if (head + 5 == lastIndex) {
      var nextWeekFirstDay = dates[lastIndex][0].add(const Duration(days: 7));
      var newWeek = createWeek(nextWeekFirstDay);
      setState(() {
        head++;
        lastIndex++;
        dates.add(newWeek);
      });
    } else if (head + 5 < lastIndex) {
      setState(() {
        head++;
      });
    }
  }

  createWeek(DateTime firstDay) {
    List<DateTime> week = [];
    for (int i = 0; i < 7; i++) {
      week.add(firstDay.add(Duration(days: i)));
    }

    return week;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Container(
                height: 50,
                child: Center(
                  child: IconButton(
                    onPressed: goUp,
                    icon: const Icon(
                      Icons.keyboard_arrow_up,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      calendarLine(head),
                      const SizedBox(height: 2),
                      calendarLine(head + 1),
                      const SizedBox(height: 2),
                      calendarLine(head + 2),
                      const SizedBox(height: 2),
                      calendarLine(head + 3),
                      // const SizedBox(height: 2),
                      // calendarLine(head + 4),
                      // const SizedBox(height: 2),
                      // calendarLine(head + 5),
                    ],
                  ),
                ),
              ),
              Container(
                height: 50,
                child: Center(
                  child: IconButton(
                    onPressed: goDown,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
