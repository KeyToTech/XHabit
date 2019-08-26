import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/scenes/auth/auth_state.dart';
import 'package:xhabits/src/presentation/widgets/xh_text_field.dart';
import 'package:xhabits/src/presentation/widgets/xh_button.dart';
import 'package:xhabits/src/presentation/widgets/xh_error_message.dart';
import 'package:xhabits/src/presentation/scenes/auth/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  static final String routeName = "/register";
  final String title;

  RegisterScreen({Key key, this.title}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // AuthBloc _authBloc = new AuthBloc();

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
    // _authBloc.registerValidate(_usernameTextEditingController.text,
    //     _emailTextEditingController.text, _passwordTextEditingController.text);
  }

  void _onSubmit(BuildContext contex) {}

  void _showToast(BuildContext contex) {
    // final snackBar =
    //     SnackBar(content: Text('Logged    ${emailController.text}'));
    // _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       key: _scaffoldKey,
  //       appBar: AppBar(
  //         title: Text("Sign up"),
  //       ),
  //       body: StreamBuilder(
  //           stream: _authBloc.loginStateObservable,
  //           builder: (context, AsyncSnapshot<AuthState> snapshot) {
  //             final authState = snapshot.data;
  //             return buildUi(context, authState);
  //           }));
  // }

  // Widget buildUi(BuildContext context, AuthState authState) {
  //   return Center(
  //     child: ListView(
  //       shrinkWrap: true,
  //       padding: EdgeInsets.only(left: 24, right: 24),
  //       children: <Widget>[
  //         new XHTextField("User name", _usernameTextEditingController, false)
  //             .field(),
  //         new XHErrorMessage(authState
  //                     .validationsState.usernameValidation.isValid
  //                 ? ""
  //                 : authState.validationsState.usernameValidation.errorMessage)
  //             .messageError(),
  //         new XHTextField("Email", _emailTextEditingController, false).field(),
  //         new XHErrorMessage(authState.validationsState.emailValidation.isValid
  //                 ? ""
  //                 : authState.validationsState.emailValidation.errorMessage)
  //             .messageError(),
  //         new XHTextField("Password", _passwordTextEditingController, true)
  //             .field(),
  //         new XHErrorMessage(authState
  //                     .validationsState.passwordValidation.isValid
  //                 ? ""
  //                 : authState.validationsState.passwordValidation.errorMessage)
  //             .messageError(),
  //         new XHButton("Sign up", authState.signInButtonEnabled)
  //             .materialButton(),
  //       ],
  //     ),
  //   );
  // }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _usernameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
