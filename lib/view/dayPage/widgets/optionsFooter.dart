import 'dart:async';

import 'package:checklife/controllers/application.controller.dart';
import 'package:flutter/material.dart';

class OptionsFooter extends StatefulWidget {
  final void Function() navigateToYesterday;
  final void Function() navigateToTomorrow;
  final ScrollController scrollController;
  final FocusNode focusNode;

  const OptionsFooter({
    Key? key,
    required this.navigateToYesterday,
    required this.navigateToTomorrow,
    required this.scrollController,
    required this.focusNode,
  }) : super(key: key);

  @override
  State<OptionsFooter> createState() => _OptionsFooterState();
}

class _OptionsFooterState extends State<OptionsFooter> {
  ApplicationController app = ApplicationController();

  _hideAddButton() {
    bool isBeforeToday = app.compare.isBeforeToday(app.currentDate);
    bool isRealocating = app.realocatedTask != null;
    return isBeforeToday || isRealocating;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          IconButton(
            onPressed: widget.navigateToYesterday,
            icon: const Icon(Icons.keyboard_arrow_left),
          ),
          Expanded(child: Container()),
          _hideAddButton()
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    int duration = 500;

                    widget.scrollController.animateTo(
                      widget.scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: duration),
                      curve: Curves.linear,
                    );
                    Timer(Duration(milliseconds: duration + 100), () {
                      widget.focusNode.requestFocus();
                    });
                  },
                  icon: const Icon(Icons.add, size: 25),
                ),
          Expanded(child: Container()),
          IconButton(
            onPressed: widget.navigateToTomorrow,
            icon: const Icon(Icons.keyboard_arrow_right),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
