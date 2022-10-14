import 'package:checklife/controllers/application.controller.dart';
import 'package:checklife/style/style.dart';
import 'package:checklife/view/login/login.dart';
import 'package:checklife/widgets/squaredIconButton.dart';
import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {
  final bool isFiltering;
  final void Function() setFilter;
  final void Function() navigateToToday;
  final Function setPageState;

  const TopBar({
    Key? key,
    required this.isFiltering,
    required this.setPageState,
    required this.setFilter,
    required this.navigateToToday,
  }) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  ApplicationController app = ApplicationController();
  final double barHeight = 75;
  final double subBarHeight = 50;

  bool isMenuLeftOpen = false;
  bool isMenuRightOpen = false;

  changeLeftMenuStatus() {
    setState(() {
      isMenuLeftOpen = !isMenuLeftOpen;
      isMenuRightOpen = false;
    });
  }

  changeRightMenuStatus() {
    setState(() {
      isMenuRightOpen = !isMenuRightOpen;
      isMenuLeftOpen = false;
    });
  }

  logout() {
    app.userService.logout();

    app.navigate.toLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: primaryColor,
          height: barHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SquaredIconButton(
                backgroundColor: isMenuLeftOpen ? primaryColorDarker : null,
                splashColor: primaryColorDarker,
                height: barHeight,
                width: barHeight,
                iconData: isMenuLeftOpen ? Icons.keyboard_arrow_up : Icons.menu,
                iconSize: isMenuLeftOpen ? 30 : 25,
                iconColor: Colors.white,
                onTap: changeLeftMenuStatus,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "${app.formatting.getWeekDay(app.currentDate)}, ${app.formatting.dayAndMonth(app.currentDate)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: Text(
                        app.formatting
                            .getRelativeDayDescription(app.currentDate),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SquaredIconButton(
                backgroundColor: isMenuRightOpen ? primaryColorDarker : null,
                splashColor: primaryColorDarker,
                height: barHeight,
                width: barHeight,
                iconData: isMenuRightOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.calendar_month,
                iconSize: isMenuRightOpen ? 30 : 22.5,
                iconColor: Colors.white,
                onTap: changeRightMenuStatus,
              ),
              // Expanded(
              //   flex: 1,
              //   child: IconButton(
              //     onPressed: () {},
              //     icon: const Icon(
              //       // filter
              //       //     ? Icons.filter_alt_off_outlined
              //       //     : Icons.filter_alt_outlined,
              //       Icons.filter_alt_outlined,
              //       color: Colors.white,
              //       size: 25,
              //     ),
              //   ),
              // ),
              // Expanded(
              //   flex: 1,
              //   child: IconButton(
              //     onPressed: () {},
              //     icon: const Icon(
              //       Icons.calendar_month,
              //       color: Colors.white,
              //       size: 25,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        isMenuLeftOpen
            ? Container(
                color: primaryColorDarker,
                height: subBarHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SquaredIconButton(
                      height: subBarHeight,
                      width: subBarHeight + 25,
                      iconData: Icons.logout,
                      iconSize: 17.5,
                      iconColor: Colors.white,
                      onTap: logout,
                    ),
                    SquaredIconButton(
                      height: subBarHeight,
                      width: subBarHeight + 25,
                      iconData: widget.isFiltering
                          ? Icons.filter_alt_off_outlined
                          : Icons.filter_alt_outlined,
                      iconSize: 20,
                      iconColor: Colors.white,
                      onTap: widget.setFilter,
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        isMenuRightOpen
            ? Container(
                color: primaryColorDarker,
                height: subBarHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SquaredIconButton(
                      height: subBarHeight,
                      width: subBarHeight + 25,
                      iconData: Icons.today,
                      iconSize: 20,
                      iconColor: Colors.white,
                      onTap: widget.navigateToToday,
                    ),
                    // SquaredIconButton(
                    //   height: subBarHeight,
                    //   width: subBarHeight + 25,
                    //   iconData: Icons.calendar_view_week,
                    //   iconSize: 20,
                    //   iconColor: Colors.white,
                    //   onTap: () {
                    //     app.navigate.toWeek(context);
                    //   },
                    // ),
                    SquaredIconButton(
                      height: subBarHeight,
                      width: subBarHeight + 25,
                      iconData: Icons.calendar_view_month,
                      iconSize: 20,
                      iconColor: Colors.white,
                      onTap: () {
                        app.navigate.toCalendar(context);
                      },
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
