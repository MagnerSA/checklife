import 'package:checklife/controllers/application.controller.dart';
import 'package:checklife/style/style.dart';
import 'package:checklife/view/dayPage/dayPage.dart';
import 'package:checklife/view/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  ApplicationController app = ApplicationController();
  double containerSize = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        containerSize = 200;
      });
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      navigateToFirstPage();
    });
  }

  navigateToFirstPage() async {
    bool testMode = false;
    Widget testedPage = Login();

    Widget initialPage;

    if (await app.userService.isUserLogged()) {
      initialPage = const DayPage();
    } else {
      initialPage = Login();
    }

    if (testMode) {
      initialPage = testedPage;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => initialPage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              // height: containerSize,
              child: Center(
                child: AnimatedContainer(
                  height: containerSize,
                  width: containerSize,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.bounceOut,
                  child: SvgPicture.asset(
                    'assets/images/AppLogoWhite.svg',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Checklife",
              style: TextStyle(
                color: Colors.white,
                fontSize: 45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
