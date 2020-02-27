import 'package:xhabits/src/data/entities/habit.dart';

abstract class HomeScreenUseCase {
  List<DateTime> weekDays(List<Habit> habits);
  Stream<List<Habit>> getHabits();

  Map<int, String> daysWords() => {
        1: 'Mon',
        2: 'Tue',
        3: 'Wed',
        4: 'Thu',
        5: 'Fri',
        6: 'Sat',
        7: 'Sun',
      };
}
