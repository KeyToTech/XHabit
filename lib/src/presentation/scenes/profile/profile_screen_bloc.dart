import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/global_notifications_update_use_case.dart';
import 'package:xhabits/src/domain/logout_use_case.dart';
import 'package:xhabits/src/domain/user_image_use_case.dart';
import 'package:xhabits/src/presentation/push_notifications_service.dart';
import 'package:xhabits/src/presentation/scenes/profile/profile_screen_state.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreenBloc {

  bool globalEnableNotifications;
  PushNotificationsService _notificationsService;

  BehaviorSubject<ProfileScreenResourse> _profileScreenStateSubject;

  BehaviorSubject<bool> _logoutStateSubject;
  BehaviorSubject<bool> _imageUploadStatusSubject;

  Stream<ProfileScreenResourse> get profileScreenStateObservable =>
      _profileScreenStateSubject.stream;
  Stream<bool> get imageUploadObservable =>
      _imageUploadStatusSubject.stream;

  Stream<bool> get logoutStateObservable => _logoutStateSubject.stream;

  LogoutUseCase _logoutUseCase;
  GlobalNotificationsUpdateUseCase _globalNotificationsUpdateUseCase;
  UserImageUseCase _userImageUseCase;

  ProfileScreenBloc(
      LogoutUseCase logoutUseCase,
      GlobalNotificationsUpdateUseCase notificationsUseCase,
      UserImageUseCase userImageUseCase,
      BuildContext context) {
    _globalNotificationsUpdateUseCase = notificationsUseCase;
    _logoutUseCase = logoutUseCase;
    _userImageUseCase = userImageUseCase;
    globalEnableNotifications = true;
    _profileScreenStateSubject = BehaviorSubject<ProfileScreenResourse>();
    if (globalEnableNotifications) {
      _notificationsService = PushNotificationsService(context);
    }
    _logoutStateSubject = BehaviorSubject<bool>();
    _imageUploadStatusSubject = BehaviorSubject<bool>.seeded(false);
    handleProfileScreenData();
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then(uploadImage);
  }

  void uploadImage(File avatar) {
    if(avatar != null) {
      _userImageUseCase.uploadProfilePic(avatar).listen(
          handleUploadImageStatus);
      handleProfileScreenData(chosenProfileImage: avatar);
    }
  }

  void handleUploadImageStatus(bool status) {
    _imageUploadStatusSubject.sink.add(status);
  }

  void handleProfileScreenData({String userImage, File chosenProfileImage}) {
    _profileScreenStateSubject.sink.add(ProfileScreenResourse(
        'Profile', 'Hello', 'World', 'helloworld@hello.hey', false,
        profileImageURL: userImage, chosenProfileImage: chosenProfileImage));
  }

  void getUserProfileImage(){
    _userImageUseCase.getProfilePic().listen(handleUserProfileImage);
  }

  void handleUserProfileImage(String image){
    handleProfileScreenData(userImage: image);
  }

  void getGlobalNotificationStatus() {
    _globalNotificationsUpdateUseCase
        .getGlobalNotificationsStatus()
        .listen(handleGlobalNotificationsData);
  }

  void handleGlobalNotificationsData(bool status) {
    globalEnableNotifications = status;
  }

  void onRateApp() {
    StoreRedirect.redirect();
  }

  void onSendFeedback() async {
    String feedbackEmail = "test@gmail.com";
    String mailUrl = 'mailto:$feedbackEmail?subject=Feedback';

    if (await canLaunch(mailUrl)) {
      await launch(mailUrl);
    } else {
      throw "Couldn't open mail application";
    }
  }

  void onNotificationsSwitcher() {
    globalEnableNotifications = !globalEnableNotifications;
    _globalNotificationsUpdateUseCase
        .updateGlobalNotifications(globalEnableNotifications);
  }

  void logout() {
    _logoutUseCase.logout().listen(onLogout);
    _notificationsService.cancelAllNotifications();
  }

  void onLogout(bool result) {
    _logoutStateSubject.sink.add(result);
  }

  void dispose() {
    _logoutStateSubject.close();
  }
}
