import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/global_notifications_update_use_case.dart';
import 'package:xhabits/src/domain/logout_use_case.dart';
import 'package:xhabits/src/presentation/scenes/profile/profile_screen_state.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreenBloc {

  GlobalNotificationsUpdateUseCase _useCase;
  bool globalEnableNotifications;
  BehaviorSubject<ProfileScreenResourse> _profileScreenStateSubject;
  BehaviorSubject<bool> _logoutStateSubject;

  Stream<ProfileScreenResourse> get ProfileScreenStateObservable =>
      _profileScreenStateSubject.stream;

  Stream<bool> get logoutStateObservable => _logoutStateSubject.stream;

  LogoutUseCase _logoutUseCase;

  ProfileScreenBloc(LogoutUseCase logoutUseCase, GlobalNotificationsUpdateUseCase useCase) {
    _useCase = useCase;
    globalEnableNotifications = true;
    _logoutUseCase = logoutUseCase;
    _profileScreenStateSubject = BehaviorSubject<ProfileScreenResourse>();
    _logoutStateSubject = BehaviorSubject<bool>();
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

  void onNotificationsSwitcher(){
    globalEnableNotifications = !globalEnableNotifications;
    _useCase.updateGlobalNotifications(globalEnableNotifications);
  }

  void logout() {
    _logoutUseCase.logout().listen(onLogout);
//    _notificationsService.cancelAllNotifications();
  }

  void onLogout(bool result) {
    _logoutStateSubject.sink.add(result);
  }

  void doSomth() {
    print('e!');
  }


  void dispose() {
    _logoutStateSubject.close();
  }
}