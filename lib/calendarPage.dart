import 'package:checklife/formatting.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Formatting formatting = Formatting();

  dayTile() {
    return Expanded(
      child: Container(
        color: Colors.green,
        child: const Center(
          child: Text("DIA"),
        ),
      ),
    );
  }

  calendarLine(int week) {
    return Expanded(
      child: Row(
        children: [
          dayTile(),
          dayTile(),
          dayTile(),
          dayTile(),
          dayTile(),
          dayTile(),
          dayTile(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime firstDay = DateTime.now()
        .subtract(const Duration(hours: 3))
        .add(const Duration(days: 1));

    print(firstDay.subtract(Duration(days: formatting.weekDay(firstDay) - 1)));

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Container(
                height: 50,
              ),
              Expanded(
                child: Column(
                  children: [
                    calendarLine(0),
                    calendarLine(0),
                    calendarLine(0),
                    calendarLine(0),
                    calendarLine(0),
                    calendarLine(0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
