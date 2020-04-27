import 'dart:io';

import 'package:flutter/material.dart';

class ProfileScreenResourse {
  String screenTitle;
  String userName;
  String userEmail;
  bool isNotificationsOn;
  String profileImageURL;
  File chosenProfileImage;

  ProfileScreenResourse(String screenTitle, String userName,
      String userEmail, bool isNotificationsOn, {String profileImageURL, File chosenProfileImage}){
    this.screenTitle = screenTitle;
    this.userName = userName;
    this.userEmail = userEmail;
    this.isNotificationsOn = isNotificationsOn;
    this.profileImageURL = profileImageURL;
    this.chosenProfileImage = chosenProfileImage;
  }
}
