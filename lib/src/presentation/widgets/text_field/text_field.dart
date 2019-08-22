import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/scenes/auth/auth_bloc.dart';

class TextField extends StatefulWidget {
  TextField({
    Key key,
    this.title,
    this.obscureText,
    this.bloc,
  }) : super(key: key);

  final String title;
  final bool obscureText;
  final LoginBloc bloc;

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_onChangeText);
  }

  void _onChangeText() {
    if (!controller.text.isEmpty)
      widget.bloc.validate(controller.text, widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: widget.title, border: OutlineInputBorder()),
      obscureText: widget.obscureText,
      controller: controller,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
