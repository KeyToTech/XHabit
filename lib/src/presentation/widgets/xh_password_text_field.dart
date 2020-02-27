import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';

class XHPasswordTextField {
  final TextEditingController textController;
  final String hint;
  final FocusNode focusNode;
  final void Function(String) onFieldSubmitted;
  final bool visibleText;
  final void Function() submit;

  XHPasswordTextField(
      this.hint, this.textController, this.visibleText, this.submit,
      {this.focusNode, this.onFieldSubmitted});

  Widget field() => Container(
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
                      icon: Icon(!visibleText
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: submit),
                  contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: hint,
                  hintStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10.0,
                      color: XHColors.lightGrey)),
              obscureText: !visibleText,
              controller: textController,
            ),
          ],
        ),
      );
}
