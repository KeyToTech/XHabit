import 'package:rxdart/rxdart.dart';

class XHBottomBarBloc {

  int currentIndex;

  BehaviorSubject<int> _currentIndexSubject;
  Stream<int> get currentIndexObservable => _currentIndexSubject.stream;

  XHBottomBarBloc(int index){
    currentIndex = index;
    _currentIndexSubject = BehaviorSubject<int>.seeded(currentIndex);
  }

  void currentIndexChanged(int index){
    currentIndex = index;
    _currentIndexSubject.sink.add(currentIndex);
  }


}