import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/scenes/profile/profile_screen_bloc.dart';
import 'package:xhabits/src/presentation/scenes/profile/profile_screen_state.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';
import 'package:xhabits/src/presentation/styles/size_config.dart';
import 'package:xhabits/src/presentation/widgets/xh_divider.dart';
import 'package:xhabits/src/presentation/widgets/xh_icon_button.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState(ProfileScreenBloc());
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileScreenBloc _profileScreenBloc;

  _ProfileScreenState(this._profileScreenBloc);

  @override
  void initState() {
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
              'helloworld@hello.hey');
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
                          Colors.deepPurple, true, false, _profileScreenBloc.doSomth)
                          .IconButton(),
                    ),
                    XHDivider().drowPickersDivider(),
                    XHIconButton('Rate this application', Icons.star,
                        Colors.amber, false, false, _profileScreenBloc.doSomth)
                        .IconButton(),
                    XHDivider().drowPickersDivider(),
                    XHIconButton('Send feedback', Icons.swap_vert, Colors.green, false, false,
                            _profileScreenBloc.doSomth)
                        .IconButton(),
                    XHDivider().drowPickersDivider(),
                    XHIconButton('Logout', null, null, false, false, _profileScreenBloc.doSomth).IconButton(),
                  ],
                ),
              ],
            ));
      });
}
