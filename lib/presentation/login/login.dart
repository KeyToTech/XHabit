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

    final loginButton = Padding(
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

    final redirectLabel = FlatButton(
        child:
            Text("Already have an account?", style: TextStyle(fontSize: 16)));

    final sizeBox = const SizedBox(height: 16.0);

    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24, right: 24),
        children: <Widget>[
          textViewEmail,
          sizeBox,
          textViewPassword,
          sizeBox,
          loginButton,
          redirectLabel
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
