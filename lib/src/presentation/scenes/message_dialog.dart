import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';
import 'package:xhabits/src/presentation/styles/size_config.dart';

class MessageDialog {
  final String titleText;
  final String messageText;

  MessageDialog(this.titleText, this.messageText);

  static void show(BuildContext context, String title, String message) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              backgroundColor: XHColors.darkGrey,
              child: Container(
                height: SizeConfig.messageDialogHeight,
                width: SizeConfig.messageDialogWidth,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: SizeConfig.messageDialogIconPadding,
                      child: Image(
                        image: AssetImage("assets/images/icon.png"),
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: SizeConfig.messageDialogLargeText,
                          color: XHColors.lightGrey),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: SizeConfig.messageDialogTextPadding,
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: SizeConfig.messageDialogSmallText,
                          color: XHColors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Divider(
                          color: Colors.black,
                          thickness: SizeConfig.pickersDividerThickness,
                          height: 1,
                        ),
                        FlatButton(
                          child: Text('Ok',
                              style: TextStyle(
                                  color: XHColors.pink,
                                  fontSize:
                                      SizeConfig.messageDialogButtonText)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }
}
