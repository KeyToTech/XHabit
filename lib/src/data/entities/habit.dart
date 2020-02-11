class Habit {
  final String habitId;
  final String title;
  final bool enableNotification;
  final List<DateTime> checkedDays;
  final DateTime startDate;
  final DateTime endDate;
  final String notificationTime;

  Habit(this.habitId, Map map)
      : title = map['title'] as String,
        enableNotification = map['enable_notification'] as bool,
        checkedDays = (map['checked_days'] as List<dynamic> ?? [])
            .map((item) => DateTime.parse(item.toString()))
            .toList(),
        startDate = DateTime.parse(map['start_date'] as String),
        endDate = DateTime.parse(map['end_date'] as String),
        notificationTime = map['notification_time'] as String;
}
