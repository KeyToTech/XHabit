import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/user.dart';
import 'package:xhabits/src/domain/login/facebook_login_use_case.dart';
import 'package:xhabits/src/presentation/resource.dart';

class FacebookLoginBloc {
  final FacebookLoginUseCase _useCase;
  BehaviorSubject<Resource<bool>> _loginStateSubject;

  Stream<Resource<bool>> get loginStateObservable => _loginStateSubject.stream;

  FacebookLoginBloc(this._useCase) {
    _loginStateSubject = BehaviorSubject<Resource<bool>>();
  }

  void login() {
    _loginStateSubject.sink.add(Resource.loading(false));
    _useCase.login().listen(_handleLogin);
  }

  void _handleLogin(User user) {
    if (user != null) {
      _loginStateSubject.sink.add(Resource.success(true));
    }
  }

  void dispose() {
    _loginStateSubject.close();
  }
}
