import 'package:rxdart/rxdart.dart';

abstract class DatabaseService {
  Observable<List<String>> getHabitIds();
  Observable<String> getHabitTitle(String habitId);
  Observable<List<DateTime>> getHabitCheckedDays(String habitId);
  void createHabit(String habitId, String title);
  void removeHabit(String habitId);
}