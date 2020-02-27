import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/data/week_days.dart';

class MockWeekDays implements WeekDays{
  @override
  List<DateTime> weekDays(List<Habit> habits) => [
    DateTime(2019, 08, 27),
    DateTime(2019, 08, 26),
    DateTime(2019, 08, 25),
    DateTime(2019, 08, 24),
    DateTime(2019, 08, 23),
    DateTime(2019, 08, 22),
    DateTime(2019, 08, 21),
  ];
}
