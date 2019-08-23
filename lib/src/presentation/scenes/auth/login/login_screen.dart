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
  LoginBloc _loginBloc = new LoginBloc();

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
    _loginBloc.validate(
        _emailTextEditingController.text, _passwordTextEditingController.text);
  }

  void _onSubmit(BuildContext contex) {}

  void _showToast(BuildContext contex) {
    // final snackBar =
    //     SnackBar(content: Text('Logged    ${emailController.text}'));
    // _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Sign in"),
        ),
        body: StreamBuilder(
            stream: _loginBloc.loginStateObservable,
            builder: (context, AsyncSnapshot<LoginState> snapshot) {
              final loginState = snapshot.data;
              return buildUi(context, loginState);
            }));
  }

  Widget buildUi(BuildContext context, LoginState loginState) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24, right: 24),
        children: <Widget>[
          new XHTextField("Email", _emailTextEditingController, false).field(),
          new XHErrorMessage(loginState.validationsState.emailValidation.isValid
                  ? ""
                  : loginState.validationsState.emailValidation.errorMessage)
              .messageError(),
          const SizedBox(height: 16.0),
          new XHTextField("Password", _passwordTextEditingController, true)
              .field(),
          new XHErrorMessage(loginState
                      .validationsState.passwordValidation.isValid
                  ? ""
                  : loginState.validationsState.passwordValidation.errorMessage)
              .messageError(),
          new XHButton("Sign in", loginState.signInButtonEnabled)
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
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
