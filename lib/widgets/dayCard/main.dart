import 'package:checklife/controllers/application.controller.dart';
import 'package:checklife/view/dayPage/dayPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../style/style.dart';

class DayCard extends StatefulWidget {
  final DateTime date;
  const DayCard({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  State<DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  ApplicationController app = ApplicationController();

  List<int> counters = [0, 0, 0, 0, 0];

  bool isLoading = false;
  String lastDate = "";

  @override
  initState() {
    _loadCounters();

    lastDate = widget.date.toString();

    super.initState();
  }

  _loadCountersWhenBuild() {
    if (lastDate != "") {
      DateTime last = DateTime.parse(lastDate);
      DateTime current = widget.date;

      if (!app.compare.isSameDay(last, current)) {
        lastDate = widget.date.toString();

        _loadCounters();
      }
    }
  }

  _loadCounters() async {
    setState(() {
      isLoading = true;
    });
    counters = await app.taskService.getTasksCount(widget.date);
    setState(() {
      isLoading = false;
    });
  }

  _navigateToDayPage() {
    app.setCurrentDate(widget.date);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const DayPage()),
      (Route<dynamic> route) => false,
    );
  }

  _getColor() {
    bool isSameDay = app.compare.isSameDay(app.today, widget.date);
    bool isBeforeToday = app.compare.isBeforeToday(widget.date);

    Color color = Colors.grey.shade300;

    if (isSameDay) color = primaryColor;
    if (isBeforeToday) color = greenColor;

    return color;
  }

  _getTextColor() {
    bool isSameDay = app.compare.isSameDay(app.today, widget.date);
    bool isBeforeToday = app.compare.isBeforeToday(widget.date);

    return isSameDay || isBeforeToday ? Colors.white : Colors.black;
  }

  _getContent() {
    bool isBeforeToday = app.compare.isBeforeToday(widget.date);

    return isLoading
        ? SpinKitDoubleBounce(
            color: isBeforeToday ? Colors.white : primaryColor,
            size: 20,
          )
        : isBeforeToday
            ? _widgetFinished()
            : _widgetContent();
  }

  _widgetFinished() {
    return Center(
      child: _widgetCounterRow(
        color: Colors.white,
        numberColor: Colors.white,
        count: counters[4],
        isFinished: true,
      ),
    );
  }

  _widgetContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _widgetCounterRow(
            count: counters[4],
            color: greenColor,
            numberColor: greenColor,
            isFinished: true,
          ),
          _widgetCounterRow(
            count: counters[1],
            numberColor: Colors.grey.shade500,
            color: redColor,
          ),
          _widgetCounterRow(
            count: counters[0],
            numberColor: Colors.grey.shade500,
            color: Colors.grey.shade400,
          ),
          _widgetCounterRow(
            count: counters[2],
            numberColor: Colors.grey.shade500,
            color: primaryColor,
          ),
          _widgetCounterRow(
            count: counters[3],
            numberColor: Colors.grey.shade500,
            color: Colors.yellow,
          ),
        ],
      ),
    );
  }

  _widgetCounterRow({
    required int count,
    required Color color,
    required Color numberColor,
    bool? isFinished,
  }) {
    bool isEmpty = count == 0;

    return isEmpty
        ? const SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Icon(
                  isFinished ?? false ? Icons.check_circle : Icons.circle,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(
                width: 2.5,
              ),
              Center(
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: numberColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    _loadCountersWhenBuild();
    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: _navigateToDayPage,
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(
                color: _getColor(),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Ink(
                  color: _getColor(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            app.formatting.monthName(widget.date.month),
                            style: TextStyle(
                              fontSize: 10,
                              color: _getTextColor(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2.5),
                        Center(
                          child: Text(
                            widget.date.day.toString(),
                            style: TextStyle(
                              color: _getTextColor(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Ink(
                    color: app.compare.isBeforeToday(widget.date)
                        ? greenColor
                        : null,
                    child: _getContent(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
