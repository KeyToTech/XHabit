import 'package:xhabits/src/data/entities/habit.dart';

class HomeScreenResource {
  final List<Habit> habits;

  final List<DateTime> weekDays;
  final Map<int, String> daysWords;
  final bool isDarkTheme;

  HomeScreenResource(this.habits, this.weekDays, this.daysWords, this.isDarkTheme);
}
