import 'package:checklife/style/style.dart';
import 'package:checklife/widgets/squaredTextButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../controllers/application.controller.dart';
import '../dayPage/dayPage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ApplicationController app = ApplicationController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loginFailed = false;

  navigateToDayPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const DayPage()),
      (Route<dynamic> route) => false,
    );
  }

  login() async {
    FocusScope.of(context).unfocus();

    Future.delayed(const Duration(milliseconds: 1000), () async {
      var success = await app.userService
          .login((emailController.text), (passwordController.text));
      print("DEU RUIM");

      if (success) {
        navigateToDayPage();
      } else {
        setState(() {
          loginFailed = true;
        });

        Future.delayed(const Duration(milliseconds: 2500), () async {
          setState(() {
            loginFailed = false;
          });
        });
      }
    });
  }

  _loginButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 25,
        right: 25,
      ),
      child: SquaredTextButton(
        text: "Login",
        height: 50,
        onTap: login,
        color: loginFailed ? redColor : primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(100)),
                child: SvgPicture.asset(
                  'assets/images/AppLogoWhite.svg',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Checklife",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                child: TextFormField(
                  decoration: const InputDecoration(hintText: "E-mail"),
                  controller: emailController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                child: TextFormField(
                  decoration: const InputDecoration(hintText: "Senha"),
                  controller: passwordController,
                ),
              ),
              const SizedBox(height: 25),
              _loginButton(),
            ],
          ),
        ),
      ),
    );
  }
}
