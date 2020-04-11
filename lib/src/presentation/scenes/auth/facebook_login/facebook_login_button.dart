import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:xhabits/src/data/api/firebase/auth/firebase_auth_service.dart';
import 'package:xhabits/src/data/user_repository.dart';
import 'package:xhabits/src/domain/login/facebook_login_use_case.dart';
import 'package:xhabits/src/presentation/resource.dart';
import 'package:xhabits/src/presentation/scenes/auth/facebook_login/facebook_login_bloc.dart';
import 'package:xhabits/src/presentation/scenes/base/base_screen.dart';

class FacebookLoginButton extends StatefulWidget {
  @override
  _FacebookLoginButtonState createState() =>
      _FacebookLoginButtonState(FacebookLoginBloc(
          FacebookLoginUseCase(UserRepository(FirebaseAuthService()))));
}

class _FacebookLoginButtonState extends State<FacebookLoginButton> {
  final FacebookLoginBloc _fbLoginBloc;

  _FacebookLoginButtonState(this._fbLoginBloc);

  void _onPressed() {
    _fbLoginBloc.loginStateObservable.listen(_handleRedirect);
    _fbLoginBloc.login();
  }

  void _handleRedirect(Resource<bool> loginState) {
    if (loginState.status == Status.SUCCESS) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BaseScreen()));
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<Resource<bool>>(
        initialData: Resource.initial(false),
        stream: _fbLoginBloc.loginStateObservable,
        builder: (context, snapshot) => buildUi(
          context,
          showLoading: snapshot.data.status == Status.LOADING,
        ),
      );

  Widget buildUi(BuildContext context, {bool showLoading}) => Center(
        child: showLoading
            ? CircularProgressIndicator()
            : SignInButton(
                Buttons.Facebook,
                text: 'Continue with Facebook',
                onPressed: _onPressed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
      );

  @override
  void dispose() {
    _fbLoginBloc.dispose();
    super.dispose();
  }
}
