import 'dart:io';
import 'package:rxdart/rxdart.dart';

abstract class UserImageUseCase {
  BehaviorSubject<bool> uploadProfilePic(File image);
  Stream<String> getProfilePic();
}