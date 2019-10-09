import 'package:xhabits/src/data/week_days.dart';

class RealWeekDays implements WeekDays {
  final DateTime _currentDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  List<DateTime> weekDays() {
    List<DateTime> result = <DateTime>[];
    DateTime currentDay = _currentDay;

    while (result.length < 5) {
      result.add(currentDay);
      currentDay = currentDay.subtract(Duration(days: 1));
    }

    return result;
  }
}
