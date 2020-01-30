import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen.dart';
import 'package:xhabits/src/presentation/widgets/xh_text_field.dart';
import 'package:xhabits/src/presentation/widgets/xh_button.dart';
import 'package:xhabits/src/presentation/widgets/xh_error_message.dart';
import 'package:xhabits/src/presentation/scenes/auth/login/login_bloc.dart';
import 'package:xhabits/src/presentation/scenes/auth/register/register_screen.dart';
import 'package:xhabits/src/presentation/scenes/auth/login/login_state.dart';
import 'package:xhabits/src/domain/login/login_use_case.dart';
import 'package:xhabits/src/data/api/firebase/firebase_auth_service.dart';

import '../../../resource.dart';
import '../../info_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() =>
      _LoginScreenState(LoginBloc(LoginUseCase(FirebaseAuthService())));
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginBloc _loginBloc;
  Size _screenSize;

  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _LoginScreenState(this._loginBloc);

  @override
  void initState() {
    super.initState();
    _emailTextEditingController.addListener(_textChange);
    _passwordTextEditingController.addListener(_textChange);
  }

  void _textChange() {
    _loginBloc.validate(
        _emailTextEditingController.text, _passwordTextEditingController.text);
  }

  void _onSubmit() {
    _loginBloc.loginStateObservable.listen(_handleRedirect);
    _loginBloc.login(
        _emailTextEditingController.text, _passwordTextEditingController.text);
  }

  void _handleRedirect(Resource<LoginState> loginState) {
    if (loginState.status == Status.SUCCESS) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(50, 51, 55, 1),
        title: Text('Sign in'),
      ),
      body: StreamBuilder(
          stream: _loginBloc.loginStateObservable,
          builder: (context, AsyncSnapshot<Resource<LoginState>> snapshot) {
            final loginState = snapshot.data.data;
            if (snapshot.data.status == Status.ERROR) {
              WidgetsBinding.instance.addPostFrameCallback((_) => InfoDialog()
                  .show(context, 'Could not login', snapshot.data.message));
            }
            _screenSize = MediaQuery.of(context).size;

            return buildUi(
                context, loginState, snapshot.data.status == Status.LOADING);
          }));

  Widget buildUi(
          BuildContext context, LoginState loginState, bool showLoading) =>
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
                        'Login',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontFamily: "Montserrat",
                          color: Color.fromRGBO(200, 200, 200, 1),
                        ),
                      ),
                    ),
                    XHTextField('Email', _emailTextEditingController, false)
                        .field(),
                    XHErrorMessage(loginState
                                .loginValidationsState.emailValidation.isValid
                            ? ''
                            : loginState.loginValidationsState.emailValidation
                                .errorMessage)
                        .messageError(),
                    XHTextField(
                            'Password', _passwordTextEditingController, true)
                        .field(),
                    XHErrorMessage(loginState.loginValidationsState
                                .passwordValidation.isValid
                            ? ''
                            : loginState.loginValidationsState
                                .passwordValidation.errorMessage)
                        .messageError(),
                  ]),
              showLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : XHButton('Login', loginState.signInButtonEnabled, _onSubmit)
                      .materialButton(),
              _screenSize.width > 360
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _dontHaveAccountChild(),
                    )
                  : Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: _dontHaveAccountChild(),
                    )
            ],
          ),
        ),
      );

  List<Widget> _dontHaveAccountChild() => <Widget>[
        const SizedBox(width: 8.0),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, RegisterScreen.routeName);
          },
          child: Text('Don\'t have an account?',
              style: TextStyle(
                  color: Color.fromRGBO(255, 51, 103, 1.0),
                  fontWeight: FontWeight.bold)),
        )
      ];

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _loginBloc.closeStream;
    super.dispose();
  }

  void navigateToRegisterScreen() {
    Navigator.pushNamed(context, RegisterScreen.routeName);
  }
}
