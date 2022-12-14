import 'package:checklife/controllers/application.controller.dart';
import 'package:checklife/style/style.dart';
import 'package:checklife/view/calendarPage/calendarPage.dart';
import 'package:checklife/view/dayPage/dayPage.dart';
import 'package:checklife/view/login/login.dart';
import 'package:checklife/view/splash/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  isLoggedIn() async {
    ApplicationController app = ApplicationController();

    return await app.userService.isUserLogged();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checklife',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
          background: backgroundColor,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Splash(),
    );
  }
}
