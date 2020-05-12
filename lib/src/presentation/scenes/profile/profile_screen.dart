import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/config/app_config.dart';
import 'package:xhabits/src/data/api/firebase/auth/firebase_auth_service.dart';
import 'package:xhabits/src/data/user_repository.dart';
import 'package:xhabits/src/domain/global_notifications_update_use_case.dart';
import 'package:xhabits/src/domain/simple_global_notifications_update_use_case.dart';
import 'package:xhabits/src/domain/simple_logout_use_case.dart';
import 'package:xhabits/src/domain/simple_update_username_use_case.dart';
import 'package:xhabits/src/domain/simple_user_email_use_case.dart';
import 'package:xhabits/src/domain/simple_user_image_use_case.dart';
import 'package:xhabits/src/domain/update_username_use_case.dart';
import 'package:xhabits/src/domain/user_email_use_case.dart';
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
      SimpleUserImageUseCase(UserRepository(FirebaseAuthService())),
      SimpleUpdateUsernameUseCase(UserRepository(FirebaseAuthService())),
      SimpleUserEmailUseCase(UserRepository(FirebaseAuthService())));
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _usernameController;
  ProfileScreenBloc _profileScreenBloc;
  FocusNode _usernameFocusNode;

  _ProfileScreenState(
      SimpleLogoutUseCase logoutUseCase,
      GlobalNotificationsUpdateUseCase notificationsUseCase,
      UserImageUseCase userImageUseCase,
      UpdateUsernameUseCase usernameUseCase,
      UserEmailUseCase emailUseCase) {
    _profileScreenBloc = ProfileScreenBloc(logoutUseCase, notificationsUseCase,
        userImageUseCase, usernameUseCase, emailUseCase, context);
    _usernameController = TextEditingController(text: null);
    _usernameFocusNode = FocusNode();
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
        _usernameController.text = resourse.userName;
        _usernameController.selection = TextSelection.fromPosition(
            TextPosition(offset: _usernameController.text.length));
        Size textSize = _textSize(_usernameController.text,
            TextStyle(fontSize: SizeConfig.profileScreenUserName));

        return _body(context, resourse, imageStatus, getImage(resourse), textSize);
      });

  ImageProvider getImage(ProfileScreenResourse resourse) {
    ImageProvider image;
    if (resourse.chosenProfileImage == null) {
      if (resourse.profileImageURL == null) {
        image = AssetImage("assets/images/blank_avatar.png");
      } else {
        image = NetworkImage(resourse.profileImageURL);
      }
    } else {
      Uint8List bytes = resourse.chosenProfileImage.readAsBytesSync();
      image = MemoryImage(bytes);
    }
    return image;
  }

  Widget _body(BuildContext context, ProfileScreenResourse resourse,
          bool imageStatus, ImageProvider image, Size textFieldSize) =>
      GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          color: XHColors.darkGrey,
          alignment: Alignment.center,
          child: ListView(
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
                      padding:
                          SizeConfig.profileImageUploadStatusIndicatorPadding,
                      child: imageStatus ? CircularProgressIndicator() : null,
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
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: textFieldSize.width + 50,
                              child: TextField(
                                focusNode: _usernameFocusNode,
                                style: TextStyle(
                                  fontSize: SizeConfig.profileScreenUserName,
                                ),
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20),
                                ],
                                controller: _usernameController,
                                onSubmitted: (value) {
                                  _profileScreenBloc.onUsernameChange(value);
                                },
                                decoration: InputDecoration(
                                  fillColor: XHColors.darkGrey,
                                  filled: true,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              transform: SizeConfig.profileScreenUserNameEditIconPadding,
                              child: IconButton(
                                icon: Icon(
                                  Icons.create,
                                  color: XHColors.lightGrey,
                                ),
                                onPressed: () => _usernameFocusNode.requestFocus(),
                                iconSize: SizeConfig.profileScreenUserNameEditIcon,
                              ),
                            )
                          ],
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
              Padding(
                padding: SizeConfig.profileScreenFirstButtonPadding,
              ),
              Container(
                padding: SizeConfig.profileScreenListViewPadding,
                child: Column(
                  children: <Widget>[
                    XHIconButton('Allow notifications', Icons.cached,
                            Colors.deepPurple, true, null,
                            switcherValue: resourse.isNotificationsOn,
                            onSwitcherAction:
                                _profileScreenBloc.onNotificationsSwitcher)
                        .IconButton(),
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
              ),
              SizedBox(
                height: SizeConfig.handleKeyboardHeight(context),
              ),
            ],
          ),
        ),
      );

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  void _handleLogoutRedirect(bool wasLoggedOut) {
    Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
