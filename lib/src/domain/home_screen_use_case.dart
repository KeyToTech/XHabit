import 'package:rxdart/rxdart.dart';

abstract class HomeScreenUseCase {
  List<DateTime> weekDays();

  Map<int, String> daysWords();
}
