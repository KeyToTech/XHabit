import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/widgets/xh_text_field.dart';
import 'package:xhabits/src/presentation/widgets/xh_button.dart';
import 'package:xhabits/src/presentation/widgets/xh_error_message.dart';
import 'package:xhabits/src/presentation/scenes/auth/auth_bloc.dart';
import 'package:xhabits/src/presentation/scenes/auth/login/login_state.dart';

class RegisterScreen extends StatefulWidget {
  static final String routeName = "/register";
  final String title;

  RegisterScreen({Key key, this.title}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  LoginBloc _loginBloc = new LoginBloc();

  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _usernameTextEditingController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _emailTextEditingController.addListener(textChange);
    _passwordTextEditingController.addListener(textChange);
  }

  void textChange() {
    _loginBloc.validate(
        _emailTextEditingController.text, _passwordTextEditingController.text);
  }

  void _onSubmit(BuildContext contex) {}

  void _showToast(BuildContext contex) {
    // final snackBar =
    //     SnackBar(content: Text('Logged    ${emailController.text}'));
    // _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Sign up"),
        ),
        body: StreamBuilder(
            stream: _loginBloc.loginStateObservable,
            builder: (context, AsyncSnapshot<LoginState> snapshot) {
              final loginState = snapshot.data;
              return buildUi(context, loginState);
            }));
  }

  Widget buildUi(BuildContext context, LoginState loginState) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24, right: 24),
        children: <Widget>[
          new XHTextField("User name", _emailTextEditingController, false)
              .field(),
          new XHErrorMessage(loginState.validationsState.emailValidation.isValid
                  ? ""
                  : loginState.validationsState.emailValidation.errorMessage)
              .messageError(),
          new XHTextField("Email", _emailTextEditingController, false).field(),
          new XHErrorMessage(loginState.validationsState.emailValidation.isValid
                  ? ""
                  : loginState.validationsState.emailValidation.errorMessage)
              .messageError(),
          new XHTextField("Password", _passwordTextEditingController, true)
              .field(),
          new XHErrorMessage(loginState
                      .validationsState.passwordValidation.isValid
                  ? ""
                  : loginState.validationsState.passwordValidation.errorMessage)
              .messageError(),
          new XHButton("Sign up", loginState.signInButtonEnabled)
              .materialButton()
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
