abstract class HabitDataUseCase {
  String habitTitle();

  List<DateTime> checkedDays();

  double progress();

  bool isChecked(DateTime dateTime);
}
