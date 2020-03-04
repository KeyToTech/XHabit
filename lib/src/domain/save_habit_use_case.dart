abstract class CreateHabitUseCase {
  Stream<bool> createHabit(String habitId, String title, bool enableNotification, String startDate, bool isSelected,
   {String endDate, String notificationTime});

  Stream<bool> updateHabit(String habitId, String title, bool enableNotification, String startDate, bool isSelected,
      List<DateTime> checkedDays, {String endDate, String notificationTime});
}
