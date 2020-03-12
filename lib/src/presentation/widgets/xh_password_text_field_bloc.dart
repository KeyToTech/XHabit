import 'package:rxdart/rxdart.dart';

class PasswordTextFieldBloc{
  bool visiblePassword;

  BehaviorSubject<bool> _visiblePasswordSubject;
  Stream<bool> get visiblePasswordObservable => _visiblePasswordSubject.stream;

  PasswordTextFieldBloc(bool visibleText) {
    visiblePassword = false;
    _visiblePasswordSubject =
    BehaviorSubject<bool>.seeded(visiblePassword);
  }

  void passwordVisibilityChanged() {
    visiblePassword = !visiblePassword;
    _visiblePasswordSubject.sink.add(visiblePassword);
  }
}