import 'package:checklife/style/style.dart';
import 'package:flutter/material.dart';

class Types {
  final _colors = {
    0: Colors.grey[400],
    1: redColor,
    2: primaryColor,
    3: Colors.yellow,
    4: greenColor,
  };
  final _backgroundColors = {
    0: Colors.white,
    1: redColor,
    2: primaryColor,
    3: Colors.yellow,
    4: greenColor,
  };
  final _constrastColors = {
    0: Colors.grey[400],
    1: Colors.white,
    2: Colors.white,
    3: Colors.white,
    4: Colors.white,
  };

  final _titles = {
    0: "Tarefa simples",
    1: "Tarefa urgente",
    2: "Tarefa fútil",
    3: "Lembrete",
    4: "Finalizada"
  };

  final _positions = {
    0: "Tarefa simples",
    1: "Tarefa urgente",
    2: "Tarefa fútil",
    3: "Lembrete",
  };

  getColor(int type) {
    return _colors[type];
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
