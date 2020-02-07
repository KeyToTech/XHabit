import 'package:xhabits/src/data/api/database_service.dart';
import 'package:xhabits/src/data/entities/habit.dart';

class MockHabitData implements DatabaseService {
  String title = 'Habit title';

  List<DateTime> checkedDays = [
    DateTime(2019, 08, 25),
    DateTime(2019, 08, 24),
    DateTime(2019, 08, 21),
  ];

  @override
  Stream<bool> createHabit(String habitId, String title, bool enableNotification,
          String startDate, String endDate, {String notificationTime}) =>
      null;

  @override
  Stream<List<Habit>> getHabits() => Stream.value(<Habit>[
        Habit('mockId1', {
          'title': 'mockaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa title1',
          'checked_days': [],
          'start_date': '2019-09-20 00:00:00.000',
          'end_date': '2019-09-30 00:00:00.000',
          'notification_time': '17:25'
        }),
        Habit('mockId2', {
          'title': 'mock title2',
          'checked_days': [],
          'start_date': '2019-09-20 00:00:00.000',
          'end_date': '2019-09-30 00:00:00.000',
          'notification_time': '17:25'
        }),
        Habit('mockId3', {
          'title': 'mock title3',
          'checked_days': [],
          'start_date': '2019-09-20 00:00:00.000',
          'end_date': '2019-09-30 00:00:00.000',
          'notification_time': '17:25'
        })
      ]);

  @override
  void removeHabit(String habitId) {}

  @override
  void updateCheckedDays(String habitId, List<DateTime> checkedDays) {}

  @override
  Stream<bool> updateHabit(String habitId, String title, bool enableNotification,
          String startDate, String endDate, List<DateTime> checkedDays, {String notificationTime}) =>
      null;
}
