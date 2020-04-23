import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/database_service.dart';
import 'package:xhabits/src/domain/user_image_use_case.dart';

class SimpleUserImageUseCase implements UserImageUseCase {
  final DatabaseService _service;

  SimpleUserImageUseCase(this._service);

  @override
  BehaviorSubject<bool> uploadProfilePic(File image) =>
      _service.uploadProfilePic(image);

  @override
  Stream<String> getProfilePic() => _service.getProfilePic();
}
