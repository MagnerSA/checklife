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

  bool isBeforeToday(DateTime date) {
    DateTime today = DateTime.now()
        .subtract(const Duration(hours: 3))
        .add(const Duration(days: 0));

    today = DateTime(
      today.year,
      today.month,
      today.day,
    );

    return date.compareTo(today) < 0;
  }
}
