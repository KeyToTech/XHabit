import 'package:flutter/material.dart';

class LoginUi extends StatefulWidget {
  LoginUi({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginUiState createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: buildUi(context));
  }

  Widget buildUi(BuildContext context) {
    final textViewEmail = TextFormField(
      decoration: const InputDecoration(
          labelText: 'Email', border: OutlineInputBorder()),
    );

    final textViewPassword = TextFormField(
      decoration: const InputDecoration(
          labelText: 'Password', border: OutlineInputBorder()),
    );

    final loginButton = Material(
      shadowColor: Colors.lightBlueAccent.shade100,
      elevation: 3.0,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        minWidth: 400.0,
        height: 42.0,
        child: Text(
          "Sign in",
          style: TextStyle(fontSize: 16),
        ),
        color: Colors.redAccent,
      ),
    );

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              textViewEmail,
              const SizedBox(height: 16.0),
              textViewPassword,
              const SizedBox(height: 32.0),
              loginButton
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
