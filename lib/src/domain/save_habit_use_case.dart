abstract class CreateHabitUseCase {
  Stream<bool> createHabit(String habitId, String title, bool enableNotification, String startDate,
      String endDate, {String notificationTime});

  Stream<bool> updateHabit(String habitId, String title, bool enableNotification, String startDate,
      String endDate, List<DateTime> checkedDays, {String notificationTime});
}
