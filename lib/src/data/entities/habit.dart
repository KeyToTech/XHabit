class Habit {
  final String title;
  final String description;
  final List<DateTime> checkedDays;
  final DateTime startDate;
  final DateTime endDate;

  Habit(Map map)
      : title = map['title'] as String,
        description = map['description'] as String,
        checkedDays = (map['checked_days'] as List<dynamic> ?? [])
            .map((item) => DateTime.parse(item.toString()))
            .toList(),
        startDate = DateTime.parse(map['start_date'] as String),
        endDate = DateTime.parse(map['end_date'] as String);
}
