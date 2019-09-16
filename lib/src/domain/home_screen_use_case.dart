import 'package:rxdart/rxdart.dart';

abstract class HomeScreenUseCase {
  List<DateTime> weekDays();
  Observable<List<String>> habitIds();

  Map<int, String> daysWords() => {
        1: 'Mon',
        2: 'Tue',
        3: 'Wed',
        4: 'Thu',
        5: 'Fri',
        6: 'Sat',
        7: 'Sun',
      };
}
