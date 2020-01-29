import 'package:xhabits/src/data/entities/habit.dart';

abstract class DatabaseService {
  Stream<List<Habit>> getHabits();

  Stream<bool> createHabit(String habitId, String title, String startDate,
      String endDate, String notificationTime);

  Stream<bool> updateHabit(String habitId, String title, String startDate,
      String endDate, String notificationTime, List<DateTime> checkedDays);

  void removeHabit(String habitId);

  void updateCheckedDays(String habitId, List<DateTime> checkedDays);
}
