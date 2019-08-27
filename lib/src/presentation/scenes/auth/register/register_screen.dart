import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/scenes/auth/auth_state.dart';
import 'package:xhabits/src/presentation/widgets/xh_text_field.dart';
import 'package:xhabits/src/presentation/widgets/xh_button.dart';
import 'package:xhabits/src/presentation/widgets/xh_error_message.dart';
import 'package:xhabits/src/presentation/scenes/auth/auth_bloc.dart';

@immutable
class RegisterScreen extends StatefulWidget {
  static final String routeName = '/register';
  final String title;

  const RegisterScreen({Key key, this.title}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _authBloc = AuthBloc();

  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _usernameTextEditingController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _usernameTextEditingController.addListener(textChange);
    _emailTextEditingController.addListener(textChange);
    _passwordTextEditingController.addListener(textChange);
  }

  void textChange() {
    _authBloc.registerValidate(_usernameTextEditingController.text,
        _emailTextEditingController.text, _passwordTextEditingController.text);
  }

  void _onSubmit() {
    _showToast();
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
        title: Text('Sign up'),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24, right: 24),
          children: <Widget>[
            StreamBuilder<SignUpValidationsState>(
              stream: _authBloc.registerStateObservable,
              builder:
                  (context, AsyncSnapshot<SignUpValidationsState> snapshot) {
                final signUpState = snapshot.data;
                return buildForm(context, signUpState);
              },
            ),
            StreamBuilder<AuthState>(
              stream: _authBloc.authStateObservable,
              builder: (context, AsyncSnapshot<AuthState> snapshot) {
                final authState = snapshot.data;
                return buildButton(context, authState);
              },
            )
          ],
        ),
      ));

  Widget buildButton(BuildContext context, AuthState authState) {
    XHButton xhButton =
        XHButton('Sign up', authState.signInButtonEnabled, _onSubmit);
    return xhButton.materialButton();
  }

  Widget buildForm(BuildContext context, SignUpValidationsState sigUpState) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          XHTextField('User name', _usernameTextEditingController, false)
              .field(),
          XHErrorMessage(sigUpState.usernameValidation.isValid
                  ? ''
                  : sigUpState.usernameValidation.errorMessage)
              .messageError(),
          const SizedBox(height: 16.0),
          XHTextField('Email', _emailTextEditingController, false).field(),
          XHErrorMessage(sigUpState.emailValidation.isValid
                  ? ''
                  : sigUpState.emailValidation.errorMessage)
              .messageError(),
          const SizedBox(height: 16.0),
          XHTextField('Password', _passwordTextEditingController, true).field(),
          XHErrorMessage(sigUpState.passwordValidation.isValid
                  ? ''
                  : sigUpState.passwordValidation.errorMessage)
              .messageError(),
        ]);
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _usernameTextEditingController.dispose();
    super.dispose();
  }
}
