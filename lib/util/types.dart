import 'package:checklife/style/style.dart';
import 'package:flutter/material.dart';

class TypesController {
  final _colors = {
    Types.simple: Colors.grey[400],
    Types.closed: greenColor,
    Types.urgent: redColor,
    Types.futile: blueColor,
    Types.reminder: yellowColor,
  };
  final _darkColors = {
    Types.simple: Colors.grey[700],
    Types.closed: darkGreenColor,
    Types.urgent: darkRedColor,
    Types.futile: darkBlueColor,
    Types.reminder: darkYellowColor,
  };
  final _backgroundColors = {
    Types.simple: Colors.white,
    Types.closed: greenColor,
    Types.urgent: redColor,
    Types.futile: blueColor,
    Types.reminder: yellowColor,
  };
  final _constrastColors = {
    Types.simple: greyColor,
    Types.closed: Colors.white,
    Types.urgent: Colors.white,
    Types.futile: Colors.white,
    Types.reminder: Colors.white,
  };

  final _titles = {
    0: "Tarefa simples",
    1: "Finalizada",
    2: "Tarefa urgente",
    3: "Tarefa fútil",
    4: "Lembrete"
  };

  getColor(int type) {
    return _colors[type];
  }

  getDarkColor(int type) {
    return _darkColors[type];
  }

  getTitle(int type) {
    return _titles[type];
  }

  getBackgroundColor(int type) {
    return _backgroundColors[type];
  }

  getContrastColor(int type) {
    return _constrastColors[type];
  }
}

class Types {
  Types._();

  static const int simple = 0;
  static const int closed = 1;
  static const int urgent = 2;
  static const int futile = 3;
  static const int reminder = 4;
}
