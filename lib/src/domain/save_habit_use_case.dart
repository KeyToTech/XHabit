abstract class CreateHabitUseCase {
  Stream<bool> createHabit(String habitId, String title, String description,
      String startDate, String endDate, String notificationTime);
  Stream<bool> updateHabit(String habitId, String title, String description,
      String startDate, String endDate, String notificationTime);
}
