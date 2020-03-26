import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/presentation/scenes/profile/profile_screen_state.dart';

class ProfileScreenBloc {
  BehaviorSubject<ProfileScreenResourse> _profileScreenStateSubject;

  Stream<ProfileScreenResourse> get ProfileScreenStateObservable =>
      _profileScreenStateSubject.stream;

  ProfileScreenBloc() {
    _profileScreenStateSubject = BehaviorSubject<ProfileScreenResourse>();
  }

  void doSomth(){
    print('e!');
  }

}
