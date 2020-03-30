import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/presentation/push_notifications_service.dart';
import 'package:xhabits/src/presentation/scenes/profile/profile_screen_state.dart';
import 'package:store_redirect/store_redirect.dart';

class ProfileScreenBloc {

  PushNotificationsService _notificationsService;
  BehaviorSubject<ProfileScreenResourse> _profileScreenStateSubject;

  Stream<ProfileScreenResourse> get ProfileScreenStateObservable =>
      _profileScreenStateSubject.stream;

  ProfileScreenBloc() {

    _profileScreenStateSubject = BehaviorSubject<ProfileScreenResourse>();
  }

  void onRateApp(){
      StoreRedirect.redirect();
  }

  void doSomth(){
    print('e!');
  }

}
