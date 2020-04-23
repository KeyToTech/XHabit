import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/config/app_config.dart';
import 'package:xhabits/src/data/api/firebase/auth/firebase_auth_service.dart';
import 'package:xhabits/src/data/user_repository.dart';
import 'package:xhabits/src/domain/global_notifications_update_use_case.dart';
import 'package:xhabits/src/domain/simple_global_notifications_update_use_case.dart';
import 'package:xhabits/src/domain/simple_logout_use_case.dart';
import 'package:xhabits/src/domain/simple_user_image_use_case.dart';
import 'package:xhabits/src/domain/user_image_use_case.dart';
import 'package:xhabits/src/presentation/scenes/auth/login/login_screen.dart';
import 'package:xhabits/src/presentation/scenes/confirm_dialog.dart';
import 'package:xhabits/src/presentation/scenes/profile/profile_screen_bloc.dart';
import 'package:xhabits/src/presentation/scenes/profile/profile_screen_state.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';
import 'package:xhabits/src/presentation/styles/size_config.dart';
import 'package:xhabits/src/presentation/widgets/xh_divider.dart';
import 'package:xhabits/src/presentation/widgets/xh_icon_button.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen();

  @override
  _ProfileScreenState createState() => _ProfileScreenState(
      SimpleLogoutUseCase(UserRepository(FirebaseAuthService())),
      SimpleGlobalNotificationsUpdateUseCase(AppConfig.database),
      SimpleUserImageUseCase(AppConfig.database));
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileScreenBloc _profileScreenBloc;

  _ProfileScreenState(
      SimpleLogoutUseCase logoutUseCase,
      GlobalNotificationsUpdateUseCase notificationsUseCase,
      UserImageUseCase userImageUseCase) {
    _profileScreenBloc = ProfileScreenBloc(
        logoutUseCase, notificationsUseCase, userImageUseCase, context);
    _profileScreenBloc.getGlobalNotificationStatus();
    _profileScreenBloc.handleProfileScreenData();
    _profileScreenBloc.getUserProfileImage();
  }

  @override
  void initState() {
    _profileScreenBloc.logoutStateObservable.listen(_handleLogoutRedirect);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: Rx.combineLatest2(
          _profileScreenBloc.profileScreenStateObservable,
          _profileScreenBloc.imageUploadObservable,
          (first, second) => [first, second]),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container(
            color: XHColors.darkGrey,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        ProfileScreenResourse resourse =
            snapshot.data[0] as ProfileScreenResourse;
        bool imageStatus = snapshot.data[1] as bool;

        return Scaffold(
            body: _body(context, resourse, imageStatus, getImage(resourse)));
      });

  ImageProvider getImage(ProfileScreenResourse resourse) {
    ImageProvider image;
    if (resourse.profileImageURL == null) {
      if (resourse.chosenProfileImage == null) {
        image = AssetImage("assets/images/blank_avatar.png");
      } else {
        Uint8List bytes = resourse.chosenProfileImage.readAsBytesSync();
        image = MemoryImage(bytes);
      }
    } else {
      image = NetworkImage(resourse.profileImageURL);
    }
    return image;
  }

  Widget _body(BuildContext context, ProfileScreenResourse resourse,
          bool imageStatus, ImageProvider image) =>
      Container(
          color: XHColors.darkGrey,
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: SizeConfig.profileScreenTitlePadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      resourse.screenTitle,
                      style: TextStyle(
                        fontSize: SizeConfig.profileScreenTitle,
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: SizeConfig.profileImageUploadStatusIndicatorPadding,
                      child: imageStatus
                          ? CircularProgressIndicator()
                          : null,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      InkWell(
                        onTap: _profileScreenBloc.chooseFile,
                        child: Container(
                          width: SizeConfig.profileScreenAvatarSize,
                          height: SizeConfig.profileScreenAvatarSize,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            border: Border.all(
                                color: XHColors.grey,
                                width:
                                    SizeConfig.profileScreenAvatarBorderRadius),
                          ),
                          child: ClipOval(
                              clipBehavior: Clip.hardEdge,
                              child: FadeInImage(
                                  fit: BoxFit.cover,
                                  placeholder: AssetImage(
                                      "assets/images/blank_avatar.png"),
                                  image: image)),
                        ),
                      ),
                      Padding(
                        padding: SizeConfig.profileScreenUserTextPadding,
                        child: Text(
                          resourse.userName + ' ' + resourse.userSurname,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.profileScreenUserName,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      Text(
                        resourse.userEmail,
                        style: TextStyle(
                          color: XHColors.lightGrey,
                          fontSize: SizeConfig.profileScreenUserEmail,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: SizeConfig.profileScreenFirstButtonPadding,
                    child: XHIconButton('Allow notifications', Icons.cached,
                            Colors.deepPurple, true, null,
                            switcherValue:
                                _profileScreenBloc.globalEnableNotifications,
                            onSwitcherAction:
                                _profileScreenBloc.onNotificationsSwitcher)
                        .IconButton(),
                  ),
                  XHDivider().drawPickersDivider(),
                  XHIconButton('Rate this application', Icons.star,
                          Colors.amber, false, _profileScreenBloc.onRateApp)
                      .IconButton(),
                  XHDivider().drawPickersDivider(),
                  XHIconButton('Send feedback', Icons.swap_vert, Colors.green,
                          false, _profileScreenBloc.onSendFeedback)
                      .IconButton(),
                  XHDivider().drawPickersDivider(),
                  XHIconButton('Logout', null, null, false, () {
                    ConfirmDialog.show(
                      context,
                      'Logout',
                      'Are you sure you want to logout?',
                      _profileScreenBloc.logout,
                    );
                  }).IconButton(),
                ],
              ),
            ],
          ));

  void _handleLogoutRedirect(bool wasLoggedOut) {
    Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
