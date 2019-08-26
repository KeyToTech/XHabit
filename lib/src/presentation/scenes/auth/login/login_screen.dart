import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/widgets/xh_text_field.dart';
import 'package:xhabits/src/presentation/widgets/xh_button.dart';
import 'package:xhabits/src/presentation/widgets/xh_error_message.dart';
import 'package:xhabits/src/presentation/scenes/auth/auth_bloc.dart';
import 'package:xhabits/src/presentation/scenes/auth/auth_state.dart';
import 'package:xhabits/src/presentation/scenes/auth/register/register_screen.dart';

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

  void _onSubmit(BuildContext contex) {
    _showToast(contex);
  }

  void _showToast(BuildContext contex) {
    final snackBar = SnackBar(
        content: Text('Logged    ${_emailTextEditingController.text}'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Sign in'),
        ),
        body: StreamBuilder(
            stream: _authBloc.loginStateObservable,
            builder: (context, AsyncSnapshot<AuthState> snapshot) {
              final authState = snapshot.data;
              return buildUi(context, authState);
            }));
  }

  Widget buildUi(BuildContext context, AuthState authState) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24, right: 24),
        children: <Widget>[
          XHTextField('Email', _emailTextEditingController, false).field(),
          XHErrorMessage(authState.validationsState.emailValidation.isValid
                  ? ''
                  : authState.validationsState.emailValidation.errorMessage)
              .messageError(),
          const SizedBox(height: 16.0),
          XHTextField('Password', _passwordTextEditingController, true).field(),
          XHErrorMessage(authState.validationsState.passwordValidation.isValid
                  ? ''
                  : authState.validationsState.passwordValidation.errorMessage)
              .messageError(),
          XHButton('Sign in', authState.signInButtonEnabled, () {
            _onSubmit(context);
          }).materialButton(),
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
    );
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }
}
