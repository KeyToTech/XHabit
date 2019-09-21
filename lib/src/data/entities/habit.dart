class Habit {
  final String title;
  final List<DateTime> checkedDays;

  Habit(Map map)
      : title = map['title'] as String,
        checkedDays = (map['checked_days'] as List<dynamic>)
            .map((item) => DateTime.parse(item.toString())).toList();
}
