import 'package:flutter/material.dart';
import 'login_bloc.dart';
import 'login_state.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _loginBloc = new LoginBloc();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    emailController.addListener(onChangeText);
    passwordController.addListener(onChangeText);
  }

  void onChangeText() {
    _loginBloc.validate(emailController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          formFields(context, loginState),
          sizeBox,
          button(context, loginState),
          FlatButton(
              child: Text("Don't have an account? Sign up",
                  style: TextStyle(fontSize: 16)))
        ],
      ),
    );
  }

  Widget button(BuildContext context, LoginState loginState) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          shadowColor: Colors.lightBlueAccent.shade100,
          elevation: 3.0,
          color: loginState.signInButtonEnabled ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(30),
          child: MaterialButton(
            minWidth: 400.0,
            height: 42.0,
            child: Text(
              "Sign in",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () {},
          ),
        ));
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

  Widget formFields(BuildContext context, LoginState loginState) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Email', border: OutlineInputBorder()),
            controller: emailController,
          ),
          errorMessage(loginState.validationsState.emailValidation.isValid,
              loginState.validationsState.emailValidation.errorMessage),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Password', border: OutlineInputBorder()),
            controller: passwordController,
            obscureText: true,
          ),
          errorMessage(loginState.validationsState.passwordValidation.isValid,
              loginState.validationsState.passwordValidation.errorMessage),
        ]);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
