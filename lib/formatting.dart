import 'package:checklife/comparing.dart';

class Formatting {
  Comparing compare = Comparing();

  getWeekDay(DateTime date) {
    print(date.weekday);

    String weekDay = "";

    switch ((date.weekday)) {
      case 7:
        weekDay = "Domingo";
        break;
      case 1:
        weekDay = "Segunda";
        break;
      case 2:
        weekDay = "Terça";
        break;
      case 3:
        weekDay = "Quarta";
        break;
      case 4:
        weekDay = "Quinta";
        break;
      case 5:
        weekDay = "Sexta";
        break;
      case 6:
        weekDay = "Sábado";
        break;
    }

    return weekDay;
  }

  getRelativeDayDescription(DateTime date) {
    String relativeDayDescription = "";

    ;

    DateTime today = DateTime.now();
    int difference = date.difference(today).inDays;

    if (compare.isSameDay(
        date, DateTime.now().subtract(const Duration(hours: 3)))) {
      relativeDayDescription = "Hoje";
    } else if (date.compareTo(today) > 0) {
      if (difference == 0) {
        relativeDayDescription = "Amanhã";
      } else if (difference == 1) {
        relativeDayDescription = "Depois de amanhã";
      } else {
        relativeDayDescription = "Daqui a $difference dias";
      }
    } else if (date.compareTo(today) < 0) {
      if (difference == -1) {
        relativeDayDescription = "Ontem";
      } else if (difference == -2) {
        relativeDayDescription = "Anteontem";
      } else {
        relativeDayDescription = "${difference * -1} dias atrás";
      }
    }

    return relativeDayDescription;
  }

  weekDay(DateTime date) {
    int count = (date.weekday + 1) % 7;

    int newDay = count == 0 ? 7 : count;
    return newDay;
  }
}
