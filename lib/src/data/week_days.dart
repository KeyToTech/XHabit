import 'package:xhabits/src/data/entities/habit.dart';

abstract class WeekDays {
  List<DateTime> weekDays(List<Habit> habits);
}
