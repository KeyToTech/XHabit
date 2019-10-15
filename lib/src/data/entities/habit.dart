class Habit {
  final String habitId;
  final String title;
  final String description;
  final List<DateTime> checkedDays;
  final DateTime startDate;
  final DateTime endDate;
  final String notificationTime;

  Habit(this.habitId, Map map)
      : title = map['title'] as String,
        description = map['description'] as String,
        checkedDays = (map['checked_days'] as List<dynamic> ?? [])
            .map((item) => DateTime.parse(item.toString()))
            .toList(),
        startDate = DateTime.parse(map['start_date'] as String),
        endDate = DateTime.parse(map['end_date'] as String),
        notificationTime = map['notification_time'] as String;
}
