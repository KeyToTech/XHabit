import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/home_repository.dart';
import 'package:xhabits/src/domain/home_screen_use_case.dart';

class SimpleHomeScreenUseCase extends HomeScreenUseCase {
  final HomeRepository _homeRepository;

  SimpleHomeScreenUseCase(this._homeRepository);

  @override
  List<DateTime> weekDays() => _homeRepository.weekDays();

  @override
  Observable<List<String>> habitIds() {
    // TODO: implement habitIds
    return null;
  }

}
