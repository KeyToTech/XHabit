// import 'package:flutter/material.dart';
// import 'package:xhabits/src/presentation/widgets/text_field/text_field.dart'
//     as prefix0;
// import 'package:xhabits/src/presentation/widgets/button/button.dart';
// import 'package:xhabits/src/presentation/widgets/text_error/text_error.dart';
// import 'package:xhabits/src/presentation/scenes/auth/auth_bloc.dart';
// import 'package:xhabits/src/presentation/scenes/auth/auth_state.dart';

// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   LoginBloc _loginBloc = new LoginBloc();

//   final _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//   }

//   void _showToast(BuildContext contex) {
//     // final snackBar =
//     //     SnackBar(content: Text('Logged    ${emailController.text}'));
//     // _scaffoldKey.currentState.showSnackBar(snackBar);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           title: Text("Sign up"),
//         ),
//         body: StreamBuilder(
//             stream: _loginBloc.loginStateObservable,
//             builder: (context, AsyncSnapshot<LoginState> snapshot) {
//               final loginState = snapshot.data;
//               return buildUi(context, loginState);
//             }));
//   }

//   Widget buildUi(BuildContext context, LoginState loginState) {
//     final sizeBox = const SizedBox(height: 16.0);
//     return Center(
//       child: ListView(
//         shrinkWrap: true,
//         padding: EdgeInsets.only(left: 24, right: 24),
//         children: <Widget>[
//           TextFieldXH(title: "Email", obscureText: false, bloc: _loginBloc),
//           TextError(
//               isValid: loginState.validationsState.emailValidation.isValid,
//               message:
//                   loginState.validationsState.emailValidation.errorMessage),
//           const SizedBox(height: 16.0),
//           prefix0.TextFieldXH(
//               title: "Password", obscureText: true, bloc: _loginBloc),
//           TextError(
//               isValid: loginState.validationsState.passwordValidation.isValid,
//               message:
//                   loginState.validationsState.passwordValidation.errorMessage),
//           sizeBox,
//           Button(
//             title: 'Sign in',
//             state: loginState,
//             bloc: _loginBloc,
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
