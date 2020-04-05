import 'package:flutter/material.dart';
import 'package:xhabits/config/app_config.dart';
import 'package:xhabits/src/data/api/database_service.dart';
import 'package:xhabits/src/data/api/firebase/firebase_auth_service.dart';
import 'package:xhabits/src/data/user_repository.dart';
import 'package:xhabits/src/domain/global_notifications_update_use_case.dart';
import 'package:xhabits/src/domain/logout_use_case.dart';
import 'package:xhabits/src/domain/simple_global_notifications_update_use_case.dart';
import 'package:xhabits/src/domain/simple_logout_use_case.dart';
import 'package:xhabits/src/presentation/scenes/auth/login/login_screen.dart';
import 'package:xhabits/src/presentation/scenes/profile/profile_screen_bloc.dart';
import 'package:xhabits/src/presentation/scenes/profile/profile_screen_state.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';
import 'package:xhabits/src/presentation/styles/size_config.dart';
import 'package:xhabits/src/presentation/widgets/xh_divider.dart';
import 'package:xhabits/src/presentation/widgets/xh_icon_button.dart';

class ProfileScreen extends StatefulWidget {
  bool notificationsOn;

  ProfileScreen(this.notificationsOn);

  @override
  _ProfileScreenState createState() => _ProfileScreenState(
      SimpleLogoutUseCase(UserRepository(FirebaseAuthService())),
      notificationsOn,
      SimpleGlobalNotificationsUpdateUseCase(AppConfig.database));
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileScreenBloc _profileScreenBloc;

  _ProfileScreenState(SimpleLogoutUseCase logoutUseCase, bool notificationsOn,
      GlobalNotificationsUpdateUseCase notificationsUseCase) {
    _profileScreenBloc =
        ProfileScreenBloc(logoutUseCase, notificationsOn, notificationsUseCase);
  }

  @override
  void initState() {
    _profileScreenBloc.logoutStateObservable.listen(_handleLogoutRedirect);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(body: _body(context));

  Widget _body(BuildContext context) => StreamBuilder<ProfileScreenResourse>(
      stream: _profileScreenBloc.ProfileScreenStateObservable,
      builder: (context, snapshot) {
        ProfileScreenResourse resourse;
        if (snapshot.data == null) {
          resourse = ProfileScreenResourse(
              'Profile',
              'https://picsum.photos/250?image=9',
              'Hello',
              'World',
              'helloworld@hello.hey',
              false);
        } else {
          resourse = snapshot.data;
        }
        return Container(
            color: XHColors.darkGrey,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: SizeConfig.profileScreenTitlePadding,
                  child: Text(
                    resourse.screenTitle,
                    style: TextStyle(
                      fontSize: SizeConfig.profileScreenTitle,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: SizeConfig.profileScreenAvatarBorderRadius,
                          backgroundColor: Color.fromRGBO(42, 43, 47, 1),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(resourse.imageUrl),
                            radius: SizeConfig.profileScreenAvatarRadius,
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
                    XHDivider().drowPickersDivider(),
                    XHIconButton('Rate this application', Icons.star,
                            Colors.amber, false, _profileScreenBloc.onRateApp)
                        .IconButton(),
                    XHDivider().drowPickersDivider(),
                    XHIconButton('Send feedback', Icons.swap_vert, Colors.green,
                            false, _profileScreenBloc.onSendFeedback)
                        .IconButton(),
                    XHDivider().drowPickersDivider(),
                    XHIconButton('Logout', null, null, false,
                            _profileScreenBloc.logout)
                        .IconButton(),
                  ],
                ),
              ],
            ));
      });

  void _handleLogoutRedirect(bool wasLoggedOut) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
