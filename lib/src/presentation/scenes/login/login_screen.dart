import 'package:flutter/material.dart';
import 'login_block.dart';
import 'login_state.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBlock _loginBlock = new LoginBlock();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign in"),
        ),
        body: StreamBuilder(
            stream: _loginBlock.loginStateObservable,
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
          formFields,
          sizeBox,
          button,
          FlatButton(
              child: Text("Dont have an account? Sign up",
                  style: TextStyle(fontSize: 16)))
        ],
      ),
    );
  }

  Widget button = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 3.0,
        color: Colors.blue,
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

  Widget formFields = Column(children: <Widget>[
    TextFormField(
      decoration: const InputDecoration(
          labelText: 'Email', border: OutlineInputBorder()),
    ),
    const SizedBox(height: 16.0),
    TextFormField(
      decoration: const InputDecoration(
          labelText: 'Password', border: OutlineInputBorder()),
    ),
  ]);

  @override
  void dispose() {
    super.dispose();
  }
}
