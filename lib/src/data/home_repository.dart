import 'package:xhabits/src/data/api/database_service.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/data/week_days.dart';

class HomeRepository {
  final DatabaseService _service;
  final WeekDays _weekDays;

  HomeRepository(this._service, this._weekDays);

  List<DateTime> weekDays(List<Habit> habits) => _weekDays.weekDays(habits);

  Stream<List<Habit>> getHabits() => _service.getHabits();
}
