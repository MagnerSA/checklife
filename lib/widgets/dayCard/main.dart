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

    // _loadCounters();
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
    return app.compare.isBeforeToday(widget.date)
        ? _widgetFinished()
        : Center();
  }

  _widgetFinished() {
    bool isEmpty = counters[4] == 0;

    return Center(
      child: isLoading
          ? const SpinKitDoubleBounce(
              color: Colors.white,
              size: 20,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.check_circle,
                    color: isEmpty ? Colors.transparent : Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  width: 2.5,
                ),
                Center(
                  child: Text(
                    counters[4].toString(),
                    style: TextStyle(
                      color: isEmpty ? Colors.transparent : Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
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
