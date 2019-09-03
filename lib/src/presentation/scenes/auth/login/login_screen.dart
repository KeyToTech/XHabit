import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen.dart';
import 'package:xhabits/src/presentation/widgets/xh_text_field.dart';
import 'package:xhabits/src/presentation/widgets/xh_button.dart';
import 'package:xhabits/src/presentation/widgets/xh_error_message.dart';
import 'package:xhabits/src/presentation/scenes/auth/login/login_bloc.dart';
import 'package:xhabits/src/presentation/scenes/auth/register/register_screen.dart';
import 'package:xhabits/src/presentation/scenes/auth/login/login_state.dart';
import 'package:xhabits/src/domain/login/login_use_case.dart';
import 'package:xhabits/src/data/api/firebase/firebase_auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() =>
      _LoginScreenState(LoginBloc(LoginUseCase(FirebaseAuthService())));
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginBloc _loginBloc;

  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _LoginScreenState(this._loginBloc);

  @override
  void initState() {
    super.initState();
    _emailTextEditingController.addListener(_textChange);
    _passwordTextEditingController.addListener(_textChange);
  }

  void _textChange() {
    _loginBloc.validate(
        _emailTextEditingController.text, _passwordTextEditingController.text);
  }

  void _onSubmit() {
    _loginBloc.loginStateObservable.listen(_handleRedirect);
    _loginBloc.login(
        _emailTextEditingController.text, _passwordTextEditingController.text);
  }

  void _handleRedirect(LoginState loginState) {
    if (loginState.loggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else if (loginState.errorMessage.isNotEmpty) {
      _showToast(loginState.errorMessage);
    }
  }

  void _showToast(String error) {
    final snackBar = SnackBar(content: Text(error));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: StreamBuilder(
          stream: _loginBloc.loginStateObservable,
          builder: (context, AsyncSnapshot<LoginState> snapshot) {
            final loginState = snapshot.data;
            if(loginState.errorMessage != null && loginState.errorMessage.isNotEmpty) {
              _showDialog('Could not login', loginState.errorMessage);
            }
            return buildUi(context, loginState);
          }));

  Widget buildUi(BuildContext context, LoginState loginState) => Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24, right: 24),
          children: <Widget>[
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  XHTextField('Email', _emailTextEditingController, false)
                      .field(),
                  XHErrorMessage(loginState
                              .loginValidationsState.emailValidation.isValid
                          ? ''
                          : loginState.loginValidationsState.emailValidation
                              .errorMessage)
                      .messageError(),
                  const SizedBox(height: 16.0),
                  XHTextField('Password', _passwordTextEditingController, true)
                      .field(),
                  XHErrorMessage(loginState
                              .loginValidationsState.passwordValidation.isValid
                          ? ''
                          : loginState.loginValidationsState.passwordValidation
                              .errorMessage)
                      .messageError(),
                ]),
            loginState.showLoading ? Center(
              child: CircularProgressIndicator(),
            ) : XHButton('Sign in', loginState.signInButtonEnabled, _onSubmit)
                .materialButton(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Don't have an account?"),
                const SizedBox(width: 8.0),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RegisterScreen.routeName);
                  },
                  child: Text('Sign up',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline)),
                )
              ],
            ),

//            loginState.errorMessage != null && loginState.errorMessage.isNotEmpty ?
//                _showDialog("lol", loginState.errorMessage)
//                : Text('lol'),

          ],
        ),
      );

//  AlertDialog _showDialog(String title, String message) {
//    // flutter defined function
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text(title),
//          content: new Text(message),
//          actions: <Widget>[
//            // usually buttons at the bottom of the dialog
//            new FlatButton(
//              child: new Text("Close"),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//  }

  void _showDialog(String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _loginBloc.closeStream;
    super.dispose();
  }

  void navigateToRegisterScreen() {
    Navigator.pushNamed(context, RegisterScreen.routeName);
  }
}
