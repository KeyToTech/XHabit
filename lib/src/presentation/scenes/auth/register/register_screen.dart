import 'package:flutter/material.dart';
import 'package:xhabits/src/data/api/firebase/firebase_auth_service.dart';
import 'package:xhabits/src/domain/register/register_use_case.dart';
import 'package:xhabits/src/presentation/scenes/auth/register/register_state.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen.dart';
import 'package:xhabits/src/presentation/widgets/xh_text_field.dart';
import 'package:xhabits/src/presentation/widgets/xh_button.dart';
import 'package:xhabits/src/presentation/widgets/xh_error_message.dart';
import 'package:xhabits/src/presentation/scenes/auth/register/register_bloc.dart';

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
    _showToast();
  }

  void _handleRedirect(RegisterState registerState) {
    if (registerState.signedUp) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  void _showToast() {
    final snackBar = SnackBar(
        content: Text('Logged    ${_emailTextEditingController.text}'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
          stream: _registerBloc.registerStateObservable,
          builder: (context, AsyncSnapshot<RegisterState> snapshot) {
            final registerState = snapshot.data;
            return buildUi(context, registerState);
          }));

  Widget buildUi(BuildContext context, RegisterState registerState) => Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24, right: 24),
          children: <Widget>[
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              XHTextField('User name', _usernameTextEditingController, false)
                  .field(),
              XHErrorMessage(registerState
                          .registerValidationsState.userNameValidation.isValid
                      ? ''
                      : registerState.registerValidationsState
                          .userNameValidation.errorMessage)
                  .messageError(),
              const SizedBox(height: 16.0),
              XHTextField('Email', _emailTextEditingController, false).field(),
              XHErrorMessage(registerState
                          .registerValidationsState.emailValidation.isValid
                      ? ''
                      : registerState.registerValidationsState.emailValidation
                          .errorMessage)
                  .messageError(),
              const SizedBox(height: 16.0),
              XHTextField('Password', _passwordTextEditingController, true)
                  .field(),
              XHErrorMessage(registerState
                          .registerValidationsState.passwordValidation.isValid
                      ? ''
                      : registerState.registerValidationsState
                          .passwordValidation.errorMessage)
                  .messageError(),
            ]),
            XHButton('Sign up', registerState.signUpButtonEnabled, _onSubmit)
                .materialButton()
          ],
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
