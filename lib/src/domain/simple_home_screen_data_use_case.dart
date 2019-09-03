import 'package:rxdart/src/observables/observable.dart';
import 'package:xhabits/src/data/home_repository.dart';
import 'package:xhabits/src/domain/home_screen_use_case.dart';

class SimpleHomeScreenUseCase extends HomeScreenUseCase {
  final HomeRepository _homeRepository;

  SimpleHomeScreenUseCase(this._homeRepository);

  @override
  List<DateTime> weekDays() => _homeRepository.weekDays();

  @override
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
