import 'package:flutter/material.dart';
import 'package:xhabits/src/data/api/firebase/firebase_auth_service.dart';
import 'package:xhabits/src/data/user_repository.dart';
import 'package:xhabits/src/domain/register/register_use_case.dart';
import 'package:xhabits/src/presentation/resource.dart';
import 'package:xhabits/src/presentation/scenes/auth/facebook_login/facebook_login_button.dart';
import 'package:xhabits/src/presentation/scenes/auth/register/register_state.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen.dart';
import 'package:xhabits/src/presentation/scenes/info_dialog.dart';
import 'package:xhabits/src/presentation/styles/size_config.dart';
import 'package:xhabits/src/presentation/widgets/auth_inkwell.dart';
import 'package:xhabits/src/presentation/widgets/xh_password_text_field.dart';
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
      RegisterBloc(RegisterUseCase(UserRepository(FirebaseAuthService()))));
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterBloc _registerBloc;
  XHPasswordTextField _xhPasswordTextField;

  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _usernameTextEditingController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  _RegisterScreenState(this._registerBloc);

  @override
  void initState() {
    super.initState();
    _usernameTextEditingController.addListener(_textChange);
    _emailTextEditingController.addListener(_textChange);
    _passwordTextEditingController.addListener(_textChange);
    _xhPasswordTextField = XHPasswordTextField('Password',
        _passwordTextEditingController,
        true,
        focusNode: _passwordFocus);
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
  Widget build(BuildContext context) => Material(
        child: StreamBuilder(
          stream: _registerBloc.registerStateObservable,
          builder: (context, AsyncSnapshot<Resource<RegisterState>> snapshot) {
            if (snapshot.data == null) {
              return Container(
                color: XHColors.darkGrey,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final registerState = snapshot.data.data;
            if (snapshot.data.status == Status.ERROR) {
              WidgetsBinding.instance.addPostFrameCallback((_) =>
                  InfoDialog().show(context, 'Error', snapshot.data.message));
            }

            return buildUi(context, registerState);
          },
        ),
      );

  Widget buildUi(BuildContext context, RegisterState registerState) =>
      GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Background_image.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: SizeConfig.authScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: Image(
                      alignment: Alignment.center,
                      height: 100.0,
                      image: AssetImage('assets/images/Logo.png'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontFamily: 'Montserrat',
                        color: XHColors.lightGrey,
                      ),
                    ),
                  ),
                  XHTextField(
                    'User name',
                    _usernameTextEditingController,
                    obscureText: false,
                    focusNode: _usernameFocus,
                    onFieldSubmitted: (value) {
                      _fieldFocusChange(context, _usernameFocus, _emailFocus);
                    },
                  ).field(),
                  XHErrorMessage(
                    registerState
                            .registerValidationsState.userNameValidation.isValid
                        ? ''
                        : registerState.registerValidationsState
                            .userNameValidation.errorMessage,
                  ).messageError(),
                  XHTextField(
                    'Email',
                    _emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    focusNode: _emailFocus,
                    onFieldSubmitted: (value) {
                      _fieldFocusChange(context, _emailFocus, _passwordFocus);
                    },
                  ).field(),
                  XHErrorMessage(
                    registerState
                            .registerValidationsState.emailValidation.isValid
                        ? ''
                        : registerState.registerValidationsState.emailValidation
                            .errorMessage,
                  ).messageError(),
                  _xhPasswordTextField.passwordField(),
                  XHErrorMessage(
                    registerState
                            .registerValidationsState.passwordValidation.isValid
                        ? ''
                        : registerState.registerValidationsState
                            .passwordValidation.errorMessage,
                  ).messageError(),
                  XHButton(
                    'Sign up',
                    registerState.signUpButtonEnabled,
                    _onSubmit,
                  ).materialButton(),
                  AuthInkWell.inkWell(
                    context,
                    'Already have an account?',
                    navigateToRegister: false,
                  ),
                  FacebookLoginButton(),
                  SizedBox(
                    height: SizeConfig.authHandleKeyboardHeight(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _usernameTextEditingController.dispose();
    _registerBloc.closeStream;
    super.dispose();
  }
}
