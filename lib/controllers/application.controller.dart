class ApplicationController {
  DateTime today = DateTime.now()
      .subtract(const Duration(hours: 3))
      .add(const Duration(days: 0));
  late DateTime currentDate = DateTime(today.year, today.month, today.day);

  static final ApplicationController _applicationController =
      ApplicationController._internal();

  factory ApplicationController() {
    return _applicationController;
  }

  ApplicationController._internal();

  setCurrentDate(DateTime newDate) {
    currentDate = DateTime(newDate.year, newDate.month, newDate.day);
  }
  // ApplicationController() {
  //   DateTime today = DateTime.now()
  //       .subtract(const Duration(hours: 3))
  //       .add(const Duration(days: 0));

  //   currentDate = DateTime(today.year, today.month, today.day);
  // }
}
