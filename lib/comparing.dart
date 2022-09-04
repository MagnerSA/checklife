class Comparing {
  isSameDay(DateTime d1, DateTime d2) {
    bool result = false;

    bool sameDay = d1.day == d2.day;
    bool sameMonth = d1.month == d2.month;
    bool sameYear = d1.year == d2.year;

    if (sameDay && sameMonth && sameYear) {
      result = true;
    }

    return result;
  }
}
