import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';
import 'package:xhabits/src/presentation/widgets/xh_password_text_field_bloc.dart';

class XHPasswordTextField {
  PasswordTextFieldBloc _passwordTextFieldBloc;
  TextEditingController textController;
  String hint;
  FocusNode focusNode;
  void Function(String) onFieldSubmitted;

  XHPasswordTextField(String hint, TextEditingController textController, bool visibleText,
      {FocusNode focusNode, Function(String) onFieldSubmitted}){
    this.hint = hint;
    this.textController = textController;
    this.focusNode = focusNode;
    this.onFieldSubmitted = onFieldSubmitted;
    this._passwordTextFieldBloc = PasswordTextFieldBloc(visibleText);
  }

  Widget passwordField() => StreamBuilder<bool>(
    stream: _passwordTextFieldBloc.visiblePasswordObservable,
    builder: (context, snapshot) => Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              focusNode: focusNode,
              onFieldSubmitted: onFieldSubmitted,
              style: TextStyle(
                color: XHColors.lightGrey,
              ),
              decoration: InputDecoration(
                  fillColor: XHColors.grey,
                  filled: true,
                  suffixIcon: IconButton(
                      icon: Icon(_passwordTextFieldBloc.visiblePassword
                      ? Icons.visibility_off
                      : Icons.visibility
                      ),
                      onPressed: _passwordTextFieldBloc.passwordVisibilityChanged),
                  contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: hint,
                  hintStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10.0,
                      color: XHColors.lightGrey)),
              obscureText: !_passwordTextFieldBloc.visiblePassword,
              controller: textController,
            ),
          ],
        ),
      ),
  );
}
