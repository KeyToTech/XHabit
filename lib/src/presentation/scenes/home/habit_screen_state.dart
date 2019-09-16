class HomeScreenResource {
  final List<String> habitIds;
  final List<DateTime> weekDays;
  final Map<int, String> daysWords;
  final bool isDarkTheme;

  HomeScreenResource(this.habitIds, this.weekDays, this.daysWords, this.isDarkTheme);
}
