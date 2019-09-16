import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/firebase/firebase_database_service.dart';
import 'package:xhabits/src/data/mock/mock_week_days.dart';

class HomeRepository {
  List<DateTime> weekDays() => MockWeekDays().weekDays;

  Observable<List<String>> habitIds() =>
      FirebaseDatabaseService().getHabitIds();
}
