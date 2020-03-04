import 'package:xhabits/src/data/entities/habit.dart';

abstract class DatabaseService {
  Stream<List<Habit>> getHabits();

  Stream<bool> createHabit(
      String habitId, String title, bool enableNotification, String startDate, bool isSelected,
      {String endDate, String notificationTime});

  Stream<bool> updateHabit(String habitId, String title,
      bool enableNotification, String startDate, bool isSelected, List<DateTime> checkedDays,
      {String endDate, String notificationTime});

  void removeHabit(String habitId);

  void updateCheckedDays(String habitId, List<DateTime> checkedDays);
}
