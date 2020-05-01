import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';

class PrivacyPolicy {
  static Widget link() => Center(
        child: Container(
          margin: EdgeInsets.only(top: 10.0),
          child: InkWell(
            onTap: () async {
              String urlString;
              if (kIsWeb) {
                urlString = '/privacy.html';
              } else {
                urlString = 'https://xhabit-2e507.web.app/privacy.html';
              }
              await launch(urlString);
            },
            child: Text(
              'Privacy Policy',
              style: TextStyle(
                color: XHColors.pink,
              ),
            ),
          ),
        ),
      );
}
