import 'package:rxdart/rxdart.dart';

abstract class CreateHabitUseCase {
  Observable<bool> createHabit(String habitId, String title, String description,
      String startDate, String endDate);
}
