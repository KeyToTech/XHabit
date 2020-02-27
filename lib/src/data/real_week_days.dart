import 'package:xhabits/src/data/week_days.dart';
import 'package:xhabits/src/data/entities/habit.dart';

class RealWeekDays implements WeekDays {
  final DateTime _currentDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  List<DateTime> weekDays(List<Habit> habits) {
    DateTime currentDay = _currentDay;
    List<DateTime> result = <DateTime>[_currentDay];

    while (currentDay.isAfter(_minimalDate(habits)) || result.length < 5) {
      currentDay = currentDay.subtract(Duration(days: 1));
      result.add(currentDay);
    }
    return result;
  }

  DateTime _minimalDate(List<Habit> habits) {
    var result = List<Habit>.from(habits);
    result.sort((a, b) => a.startDate.compareTo(b.startDate));
    return result.isNotEmpty ? result.first.startDate : DateTime.now();
  }
}
