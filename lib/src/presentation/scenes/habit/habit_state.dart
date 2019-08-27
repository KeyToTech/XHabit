class HabitState {
  final String habitTitle;
  final List<DateTime> checkedDays;
  final List<DateTime> weekDays;
  final double progress;

  HabitState(this.habitTitle, this.checkedDays, this.weekDays, this.progress);
}
