import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/scenes/auth/auth_bloc.dart';
import 'package:xhabits/src/presentation/scenes/auth/auth_state.dart';

class Button extends StatefulWidget {
  Button({Key key, this.title, this.state, this.bloc}) : super(key: key);

  final String title;
  final LoginState state;
  final LoginBloc bloc;

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  void _onSubmit(BuildContext contex) {
    widget.bloc.login();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          shadowColor: Colors.lightBlueAccent.shade100,
          elevation: 3.0,
          color: widget.state.signInButtonEnabled ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(30),
          child: MaterialButton(
            minWidth: 400.0,
            height: 42.0,
            child: Text(
              widget.title,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: widget.state.signInButtonEnabled
                ? () => _onSubmit(context)
                : null,
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
