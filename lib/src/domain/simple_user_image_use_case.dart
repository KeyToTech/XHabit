import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/user_repository.dart';
import 'package:xhabits/src/domain/user_image_use_case.dart';

class SimpleUserImageUseCase implements UserImageUseCase {
  final UserRepository _repository;

  SimpleUserImageUseCase(this._repository);

  @override
  BehaviorSubject<bool> uploadProfilePic(File image) =>
      _repository.uploadProfilePic(image);

  @override
  Stream<String> getProfilePic() => _repository.getProfilePic();
}
