import 'package:checklife/controllers/application.controller.dart';
import 'package:checklife/view/dayPage/dayPage.dart';
import 'package:flutter/material.dart';

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

  _navigateToDayPage() {
    app.setCurrentDate(widget.date);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const DayPage()),
      (Route<dynamic> route) => false,
    );
  }

  _getColor() {
    return app.compare.isSameDay(app.today, widget.date)
        ? secondaryColor
        : Colors.grey[300];
  }

  @override
  Widget build(BuildContext context) {
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
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2.5),
                        Center(
                          child: Text(
                            widget.date.day.toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
