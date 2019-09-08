class Habit {
  final title;
  final checkedDays;

  Habit.fromMap(Map map)
      : title = map['title'],
        checkedDays = map['checked_days'];
}
