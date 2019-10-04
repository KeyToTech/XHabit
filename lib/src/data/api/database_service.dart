import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/habit.dart';

abstract class DatabaseService {
  Observable<List<Habit>> getHabits();

  Observable<bool> createHabit(String habitId, String title, String description,
      String startDate, String endDate);

  Observable<bool> updateHabit(String habitId, String title, String description,
      String startDate, String endDate);

  void removeHabit(String habitId);

  void updateCheckedDays(String habitId, List<DateTime> checkedDays);
}
