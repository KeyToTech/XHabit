import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/widgets/text_field/text_field.dart'
    as prefix0;
import 'package:xhabits/src/presentation/widgets/button/button.dart';
import 'package:xhabits/src/presentation/scenes/auth/auth_bloc.dart';
import 'package:xhabits/src/presentation/scenes/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _loginBloc = new LoginBloc();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  void _onSubmit(BuildContext contex) {
    _showToast(contex);
    _loginBloc.login();
  }

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
    final sizeBox = const SizedBox(height: 16.0);
    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24, right: 24),
        children: <Widget>[
          prefix0.TextField(
              title: "Email", obscureText: false, bloc: _loginBloc),
          errorMessage(loginState.validationsState.emailValidation.isValid,
              loginState.validationsState.emailValidation.errorMessage),
          const SizedBox(height: 16.0),
          prefix0.TextField(
              title: "Password", obscureText: true, bloc: _loginBloc),
          errorMessage(loginState.validationsState.passwordValidation.isValid,
              loginState.validationsState.passwordValidation.errorMessage),
          sizeBox,
          Button(
            title: 'Sign in',
            state: loginState,
            bloc: _loginBloc,
          ),
          FlatButton(
              child: Text("Don't have an account? Sign up",
                  style: TextStyle(fontSize: 16))),
          Text(loginState.loginResultState.loggedIn ? "The best" : "")
        ],
      ),
    );
  }

  Widget errorMessage(bool isValid, String message) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: Text(
        isValid ? "" : message,
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
