import 'package:checklife/calendarPage.dart';
import 'package:checklife/dayPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now()
        .subtract(const Duration(hours: 3))
        .add(const Duration(days: 0));

    return MaterialApp(
      title: 'Checklife',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: DayPage(
        // date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        // date: DateTime.now().subtract(const Duration(hours: 3)),
        // date: DateTime.now().subtract(const Duration(hours: 3)),
        date: DateTime(today.year, today.month, today.day),
      ),
    );
  }
}
