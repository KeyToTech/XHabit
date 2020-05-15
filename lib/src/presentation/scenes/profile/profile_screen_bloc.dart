import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/global_notifications_update_use_case.dart';
import 'package:xhabits/src/domain/logout_use_case.dart';
import 'package:xhabits/src/domain/update_username_use_case.dart';
import 'package:xhabits/src/domain/user_email_use_case.dart';
import 'package:xhabits/src/domain/user_image_use_case.dart';
import 'package:xhabits/src/domain/validation/username_validation.dart';
import 'package:xhabits/src/domain/validation/validation.dart';
import 'package:xhabits/src/presentation/push_notifications_service.dart';
import 'package:xhabits/src/presentation/scenes/profile/profile_screen_state.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

enum UsernameState { editing, notEditing }

class ProfileScreenBloc {
  UsernameState currentState;
  String username;
  PushNotificationsService _notificationsService;

  BehaviorSubject<ProfileScreenResourse> _profileScreenStateSubject;

  BehaviorSubject<bool> _logoutStateSubject;
  BehaviorSubject<bool> _imageUploadStatusSubject;
  BehaviorSubject<UsernameState> _isEditingSubject;

  Stream<ProfileScreenResourse> get profileScreenStateObservable =>
      _profileScreenStateSubject.stream;

  Stream<bool> get imageUploadObservable => _imageUploadStatusSubject.stream;

  Stream<bool> get logoutStateObservable => _logoutStateSubject.stream;

  Stream<UsernameState> get isEditingObservable => _isEditingSubject.stream;

  UserNameValidation _userNameValidation;
  final _defaultTextInputState = ValidationResult(true, null);
  LogoutUseCase _logoutUseCase;
  GlobalNotificationsUpdateUseCase _globalNotificationsUpdateUseCase;
  UserImageUseCase _userImageUseCase;
  UpdateUsernameUseCase _usernameUseCase;
  UserEmailUseCase _emailUseCase;

  ProfileScreenBloc(
      LogoutUseCase logoutUseCase,
      GlobalNotificationsUpdateUseCase notificationsUseCase,
      UserImageUseCase userImageUseCase,
      UpdateUsernameUseCase usernameUseCase,
      UserEmailUseCase emailUseCase,
      BuildContext context) {
    currentState = UsernameState.notEditing;
    _emailUseCase = emailUseCase;
    _logoutUseCase = logoutUseCase;
    _usernameUseCase = usernameUseCase;
    _userImageUseCase = userImageUseCase;
    _userNameValidation = UserNameValidation();
    _globalNotificationsUpdateUseCase = notificationsUseCase;
    _logoutStateSubject = BehaviorSubject<bool>();
    _notificationsService = PushNotificationsService(context);
    _imageUploadStatusSubject = BehaviorSubject<bool>.seeded(false);
    _isEditingSubject = BehaviorSubject<UsernameState>.seeded(UsernameState.notEditing);
    _profileScreenStateSubject = BehaviorSubject<ProfileScreenResourse>();
    getUserName();
    getUserEmail();
    getUserProfileImage();
    handleProfileScreenData();
    listenGlobalNotificationStatus();
  }

  bool isValid() {
    ValidationResult usernameValid = _defaultTextInputState;
    bool isNotEmptyUsername = username.isNotEmpty;
    if (isNotEmptyUsername) {
      usernameValid = _userNameValidation.validate(username);
    }
    return usernameValid.isValid;
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then(uploadImage);
  }

  void uploadImage(File avatar) {
    if (avatar != null) {
      _profileScreenStateSubject.value.profileImageURL = null;
      _userImageUseCase
          .uploadProfilePic(avatar)
          .listen(handleUploadImageStatus);
      handleProfileScreenData(chosenProfileImage: avatar);
    }
  }

  void handleUploadImageStatus(bool status) {
    if (!status) {
      getUserProfileImage();
    }
    _imageUploadStatusSubject.sink.add(status);
  }

  void handleProfileScreenData(
      {String userImage,
      bool isNotificationsOn,
      String username,
      File chosenProfileImage,
      String userEmail}) {
    var existingResource = _profileScreenStateSubject.value ??
        ProfileScreenResourse(screenTitle: 'Profile');
    if (username != null) {
      existingResource.userName = username;
    }
    if (userImage != null) {
      existingResource.profileImageURL = userImage;
    }
    if (chosenProfileImage != null) {
      existingResource.chosenProfileImage = chosenProfileImage;
    }
    if (isNotificationsOn != null) {
      existingResource.isNotificationsOn = isNotificationsOn;
    }
    if(userEmail != null){
      existingResource.userEmail = userEmail;
    }
    _profileScreenStateSubject.sink.add(existingResource);
  }

  void onUsernameChange(String value) {
    _usernameUseCase.updateUsername(value);
    handleProfileScreenData(username: value);
  }

  void submitUsernameChange(){
    onUsernameChange(username);
  }

  void removeLocalUsername() {
    username = _profileScreenStateSubject.value.userName;
    _profileScreenStateSubject.sink.add(_profileScreenStateSubject.value);
  }

  void editButtonPressed(){
    currentState = UsernameState.editing;
    _isEditingSubject.sink.add(currentState);
  }

  void submitButtonPressed(){
    currentState = UsernameState.notEditing;
    _isEditingSubject.sink.add(currentState);
  }

  void getUserProfileImage() {
    _userImageUseCase.getProfilePic().listen(handleUserProfileImage);
  }

  void handleUserProfileImage(String image) {
    handleProfileScreenData(userImage: image);
  }

  void getUserName() {
    _usernameUseCase.getUsername().listen(handleUsernameData);
  }

  void handleUsernameData(String un) {
    username = un;
    handleProfileScreenData(username: un);
  }

  void getUserEmail() {
    _emailUseCase.getUserEmail().listen(handleEmailData);
  }

  void handleEmailData(String email) {
    handleProfileScreenData(userEmail: email);
  }

  void listenGlobalNotificationStatus() {
    _globalNotificationsUpdateUseCase
        .getGlobalNotificationsStatus()
        .listen(handleGlobalNotificationsData);
  }

  void handleGlobalNotificationsData(bool status) {
    handleProfileScreenData(isNotificationsOn: status);
  }

  void onRateApp() {
    StoreRedirect.redirect();
  }

  void onSendFeedback() async {
    String feedbackEmail = "xhabits@keytotech.com";
    String mailUrl = 'mailto:$feedbackEmail?subject=Feedback';

    if (await canLaunch(mailUrl)) {
      await launch(mailUrl);
    } else {
      throw "Couldn't open mail application";
    }
  }

  void onNotificationsSwitcher() {
    var newValue =
        !(_profileScreenStateSubject.value.isNotificationsOn ?? true);
    handleProfileScreenData(isNotificationsOn: newValue);
    _globalNotificationsUpdateUseCase.updateGlobalNotifications(newValue);
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
