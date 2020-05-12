import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/habit.dart';

abstract class DatabaseService {
  Stream<List<Habit>> getHabits();

  Stream<bool> createHabit(
      String habitId, String title, bool enableNotification, String startDate,
      {String endDate, String notificationTime});

  Stream<bool> updateHabit(String habitId, String title,
      bool enableNotification, String startDate, List<DateTime> checkedDays,
      {String endDate, String notificationTime});

  void removeHabit(String habitId);

  void removeHabits(List<String> habitIds);

  void updateCheckedDays(String habitId, List<DateTime> checkedDays);

  Stream<bool> updateGlobalNotifications(bool notificationsOn);

  BehaviorSubject<bool> getGlobalNotificationsStatus();
}
