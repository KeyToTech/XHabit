import 'package:rxdart/rxdart.dart';

class XHIconButtonBloc {

  bool notificationsOn;

  BehaviorSubject<bool> _notificationsOnSubject;
  Stream<bool> get notificationsOnObservable => _notificationsOnSubject.stream;

  XHIconButtonBloc(bool isNotificationsOn){
    this.notificationsOn = isNotificationsOn;
    _notificationsOnSubject = BehaviorSubject<bool>.seeded(notificationsOn);
  }

  void switcherChanged(){
    notificationsOn = !notificationsOn;
    _notificationsOnSubject.sink.add(notificationsOn);
  }

}