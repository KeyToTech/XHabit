import 'package:rxdart/rxdart.dart';

abstract class HabitDataUseCase {
  Observable<String> habitTitle();

  Observable<List<DateTime>> checkedDays();

  double progress();
}
