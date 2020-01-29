abstract class CreateHabitUseCase {
  Stream<bool> createHabit(String habitId, String title, String startDate,
      String endDate, String notificationTime);

  Stream<bool> updateHabit(String habitId, String title, String startDate,
      String endDate, String notificationTime, List<DateTime> checkedDays);
}
