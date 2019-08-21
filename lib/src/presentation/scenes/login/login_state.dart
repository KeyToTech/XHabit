class LoginValidationsState {}

class LoginResultState {
  final bool loggedIn;
  final String loginError;
  final bool loading;

  LoginResultState(this.loggedIn, this.loginError, this.loading);
}

class LoginState {
  final LoginValidationsState validationsState;
  final bool signInButtonEnabled;
  final LoginResultState loginResultState;

  LoginState(
      this.validationsState, this.signInButtonEnabled, this.loginResultState);
}
