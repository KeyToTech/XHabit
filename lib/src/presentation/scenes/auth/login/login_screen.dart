import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/widgets/xh_text_field.dart';
import 'package:xhabits/src/presentation/widgets/xh_button.dart';
import 'package:xhabits/src/presentation/widgets/xh_error_message.dart';
import 'package:xhabits/src/presentation/scenes/auth/auth_bloc.dart';
import 'package:xhabits/src/presentation/scenes/auth/auth_state.dart';
import 'package:xhabits/src/presentation/scenes/auth/register/register_screen.dart';
import 'package:xhabits/src/domain/validation/email_validation.dart';
import 'package:xhabits/src/domain/validation/password_validation.dart';
import 'package:xhabits/src/domain/validation/username_validation.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthBloc _authBloc = AuthBloc();

  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _emailTextEditingController.addListener(textChange);
    _passwordTextEditingController.addListener(textChange);
  }

  void textChange() {
    _authBloc.loginValidate(
        _emailTextEditingController.text, _passwordTextEditingController.text);
  }

  void _onSubmit() {
    _showToast();
  }

  void _showToast() {
    final snackBar = SnackBar(
        content: Text('Logged    ${_emailTextEditingController.text}'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24, right: 24),
          children: <Widget>[
            StreamBuilder<SignInValidationsState>(
              stream: _authBloc.loginStateObservable,
              builder:
                  (context, AsyncSnapshot<SignInValidationsState> snapshot) {
                final signInState = snapshot.data;
                return buildForm(context, signInState);
              },
            ),
            StreamBuilder<AuthState>(
              stream: _authBloc.authStateObservable,
              builder: (context, AsyncSnapshot<AuthState> snapshot) {
                final authState = snapshot.data;
                return buildButton(context, authState);
              },
            ),
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
            )
          ],
        ),
      ));

  Widget buildButton(BuildContext context, AuthState authState) {
    XHButton xhButton =
        XHButton('Sign in', authState.signInButtonEnabled, _onSubmit);
    return xhButton.materialButton();
  }

  Widget buildForm(BuildContext context, SignInValidationsState signInState) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          XHTextField('Email', _emailTextEditingController, false).field(),
          XHErrorMessage(signInState.emailValidation.isValid
                  ? ''
                  : signInState.emailValidation.errorMessage)
              .messageError(),
          const SizedBox(height: 16.0),
          XHTextField('Password', _passwordTextEditingController, true).field(),
          XHErrorMessage(signInState.passwordValidation.isValid
                  ? ''
                  : signInState.passwordValidation.errorMessage)
              .messageError(),
        ]);
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  void navigateToRegisterScreen() {
    Navigator.pushNamed(context, RegisterScreen.routeName);
  }
}
