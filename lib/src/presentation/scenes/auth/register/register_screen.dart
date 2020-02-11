import 'package:flutter/material.dart';
import 'package:xhabits/src/data/api/firebase/firebase_auth_service.dart';
import 'package:xhabits/src/domain/register/register_use_case.dart';
import 'package:xhabits/src/presentation/resource.dart';
import 'package:xhabits/src/presentation/scenes/auth/register/register_state.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen.dart';
import 'package:xhabits/src/presentation/scenes/info_dialog.dart';
import 'package:xhabits/src/presentation/widgets/xh_text_field.dart';
import 'package:xhabits/src/presentation/widgets/xh_button.dart';
import 'package:xhabits/src/presentation/widgets/xh_error_message.dart';
import 'package:xhabits/src/presentation/scenes/auth/register/register_bloc.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';

@immutable
class RegisterScreen extends StatefulWidget {
  static final String routeName = '/register';
  final String title;

  const RegisterScreen({Key key, this.title}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState(
      RegisterBloc(RegisterUseCase(FirebaseAuthService())));
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterBloc _registerBloc;
  Size _screenSize;

  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _usernameTextEditingController = TextEditingController();

  _RegisterScreenState(this._registerBloc);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _usernameTextEditingController.addListener(_textChange);
    _emailTextEditingController.addListener(_textChange);
    _passwordTextEditingController.addListener(_textChange);
  }

  void _textChange() {
    _registerBloc.validate(_usernameTextEditingController.text,
        _emailTextEditingController.text, _passwordTextEditingController.text);
  }

  void _onSubmit() {
    _registerBloc.registerStateObservable.listen(_handleRedirect);
    _registerBloc.register(
        _emailTextEditingController.text, _passwordTextEditingController.text);
  }

  void _handleRedirect(Resource<RegisterState> registerState) {
    if (registerState.status == Status.SUCCESS) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: XHColors.darkGrey,
        title: Text(widget.title),
      ),
      body: StreamBuilder(
          stream: _registerBloc.registerStateObservable,
          builder: (context, AsyncSnapshot<Resource<RegisterState>> snapshot) {
            final registerState = snapshot.data.data;
            if (snapshot.data.status == Status.ERROR) {
              WidgetsBinding.instance.addPostFrameCallback((_) =>
                  InfoDialog().show(context, 'Error', snapshot.data.message));
            }
            _screenSize = MediaQuery.of(context).size;

            return buildUi(context, registerState);
          }));

  Widget buildUi(BuildContext context, RegisterState registerState) =>
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/Background_image.png"),
                fit: BoxFit.cover)),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
                horizontal: _screenSize.width > 1000
                    ? _screenSize.width * 0.3
                    : _screenSize.width * 0.15),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 40.0),
                    child: Image(
                      alignment: Alignment.center,
                      image: AssetImage("assets/images/Logo.png"),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontFamily: "Montserrat",
                        color: XHColors.lightGrey,
                      ),
                    ),
                  ),
                  XHTextField('User name', _usernameTextEditingController,
                          false)
                      .field(),
                  XHErrorMessage(registerState.registerValidationsState
                              .userNameValidation.isValid
                          ? ''
                          : registerState.registerValidationsState
                              .userNameValidation.errorMessage)
                      .messageError(),
                  XHTextField('Email', _emailTextEditingController, false)
                      .field(),
                  XHErrorMessage(registerState.registerValidationsState
                              .emailValidation.isValid
                          ? ''
                          : registerState.registerValidationsState
                              .emailValidation.errorMessage)
                      .messageError(),
                  XHTextField('Password', _passwordTextEditingController,
                          true)
                      .field(),
                  XHErrorMessage(registerState.registerValidationsState
                              .passwordValidation.isValid
                          ? ''
                          : registerState.registerValidationsState
                              .passwordValidation.errorMessage)
                      .messageError(),
                  ]),
                  XHButton('Sign up', registerState.signUpButtonEnabled,
                          _onSubmit)
                      .materialButton(),
                ],
              ),
          ),
      );

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _usernameTextEditingController.dispose();
    _registerBloc.closeStream;
    super.dispose();
  }
}
