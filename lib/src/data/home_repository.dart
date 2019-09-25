import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/database_service.dart';
import 'package:xhabits/src/data/api/firebase/firebase_database_service.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/data/mock/mock_week_days.dart';

class HomeRepository {
  final DatabaseService _service;

  HomeRepository(this._service);

  List<DateTime> weekDays() => MockWeekDays().weekDays;

  Observable<List<Habit>> getHabits() => _service.getHabits();
}
