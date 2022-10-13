import 'package:checklife/view/calendarPage/calendarPage.dart';
import 'package:checklife/view/login/login.dart';
import 'package:checklife/view/weekPage/weekPage.dart';
import 'package:flutter/material.dart';

class NavigationController {
  toLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (Route<dynamic> route) => false,
    );
  }

  toCalendar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CalendarPage()),
    );
  }

  toWeek(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WeekPage()),
    );
  }
}
