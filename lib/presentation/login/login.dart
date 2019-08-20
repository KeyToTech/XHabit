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
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: buildUi(context)),
        ),
      ),
    );
  }

  Widget buildUi(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(
              labelText: 'Email', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          decoration: const InputDecoration(
              labelText: 'Password', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
