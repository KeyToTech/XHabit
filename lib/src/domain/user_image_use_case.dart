import 'dart:io';

abstract class UserImageUseCase {

  void uploadProfilePic(File image);

  Stream<String> getProfilePic();

}