import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parkour_app/bloc/auth/auth_bloc.dart';
import 'package:parkour_app/bloc/auth/auth_event.dart';
import 'package:parkour_app/bloc/auth/auth_state.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:email_validator/email_validator.dart';
import 'package:parkour_app/support/router.gr.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _mail;
  String _password;
  final FocusNode _passwordNode = FocusNode();
  bool _isError = false;
  bool _isObscure = true;
  String _result;

  final AuthBloc _authBloc = GetIt.instance<AuthBloc>();
  StreamSubscription _streamSubscription;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_result == CodeStrings.resultSignupSuccess) {
        _showSnackBar(AppStrings.signedSuccessMessage, CodeStrings.typeSuccess);
      } else if (_result == CodeStrings.resultPasswordResetSuccess) {
        _showSnackBar(AppStrings.resetSuccessMessage, CodeStrings.typeSuccess);
      }
    });
    _streamSubscription = _authBloc.authSubject.listen((receivedState) {
      if (receivedState is UserIsLoggedIn) {
        if (receivedState.authUser != null) {
          MainRouter.navigator
              .pushNamedAndRemoveUntil(MainRouter.homePage, (_) => false);
        } else {
          setState(() {
            _isError = true;
          });
        }
      }
    });
    super.initState();
  }

  void _checkPassedArguments() {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    if (args != null) {
      setState(() {
        _result = args['result'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkPassedArguments();

    if (_isError) {
      _showSnackBar(AppStrings.wrongCredentials, CodeStrings.typeError);
      _isError = false;
    }

    return Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsetsDirectional.only(
                        start: 60.0, end: 60.0, top: 50.0),
                    child: Container(
                      width: 120.0,
                      height: 120.0,
                      child: Image.asset(
                        CodeStrings.appLogo,
                        color: AppColors.primaryColor,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  _buildCredentialsForm(),
                  _buildLoginButton(),
                  _buildSocialIcons(),
                  _buildRegistrationText()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCredentialsForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTextLabel(AppStrings.mailLabel),
          _buildMailField(),
          _buildTextLabel(AppStrings.passwordLabel),
          _buildPasswordField(),
        ],
      ),
    );
  }

  Widget _buildTextLabel(String label) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 20, end: 20, top: 40),
      child: Text(
        label,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMailField() {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 20, end: 20, top: 10),
      child: TextFormField(
        validator: (mail) {
          print('XXX -> $mail');
          if (mail.isEmpty) {
            return AppStrings.mailRequired;
          }

          if (!_isValidEmail(mail)) {
            return AppStrings.mailInvalid;
          }
          _mail = mail;
          return null;
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: AppStrings.mailHint,
          hintStyle: TextStyle(color: AppColors.darkGrey),
        ),
        onFieldSubmitted: (_) =>
            FocusScope.of(context).requestFocus(_passwordNode),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 20, end: 20, top: 10),
      child: TextFormField(
        focusNode: _passwordNode,
        validator: (password) {
          print('XXX -> $password');
          if (password.isEmpty) {
            return AppStrings.passwordRequired;
          }

          if (!_isValidPassword(password)) {
            return AppStrings.passwordInvalidError;
          }
          return null;
        },
        obscureText: _isObscure,
        decoration: InputDecoration(
          errorMaxLines: 2,
          hintText: AppStrings.passwordHint,
          hintStyle: TextStyle(color: AppColors.darkGrey),
          suffixIcon: Container(
            margin: EdgeInsets.only(left: 10, right: 16),
            child: IconButton(
                icon: _isObscure
                    ? Icon(
                        Icons.visibility_off,
                        color: AppColors.offGrey,
                      )
                    : Icon(
                        Icons.visibility,
                        color: AppColors.offGrey,
                      ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                }),
          ),
          suffix: InkWell(
            onTap: () =>
                MainRouter.navigator.pushNamed(MainRouter.passwordResetScreen),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 16),
              child: Text(
                AppStrings.passwordForgot,
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcons() {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 20, end: 20, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              _authBloc.dispatch(LoginWithGoogleRequested());
            },
            child: Image.asset(
              CodeStrings.googleIcon,
              width: 40.0,
              height: 40.0,
            ),
          ),
//          SizedBox(
//            width: 40,
//          ),
//          InkWell(
//            onTap: () {
//              ///TODO: Login with Facebook
//            },
//            child: Image.asset(CodeStrings.facebookIcon,
//                width: 40.0, height: 40.0),
//          ),
        ],
      ),
    );
  }

  bool _isValidEmail(String mail) {
    return EmailValidator.validate(mail);
  }

  bool _isValidPassword(String password) {
    RegExp _lettersRegex = RegExp('[a-zA-Z]');
    RegExp _numbersRegex = RegExp('[0-9]');
    RegExp _specialCharsRegex = RegExp(r'[_\-=@,\.;!#*&%+()^]+$');

    if (password.length < 8) {
      return false;
    }
    if (!_lettersRegex.hasMatch(password)) {
      return false;
    }
    if (!_numbersRegex.hasMatch(password)) {
      return false;
    }

    if (!_specialCharsRegex.hasMatch(password)) {
      return false;
    }

    _password = password;
    return true;
  }

  Widget _buildLoginButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70.0,
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      margin: EdgeInsetsDirectional.only(start: 20, end: 20, top: 30),
      child: RaisedButton(
        color: AppColors.primaryColor,
        child: Text(
          AppStrings.loginText,
          style: TextStyle(
              color: AppColors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _authBloc
                .dispatch(LoginWithEmailAndPasswordRequested(_mail, _password));
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildRegistrationText() {
    return Container(
      margin:
          EdgeInsetsDirectional.only(start: 20, end: 20, top: 20, bottom: 20.0),
      alignment: AlignmentDirectional.center,
      child: InkWell(
        onTap: () {
          MainRouter.navigator.pushReplacementNamed(MainRouter.signUpPage);
        },
        child: Text(
          AppStrings.newAccountText,
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message, String type) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: Row(
          children: <Widget>[
            Icon(
                type == CodeStrings.typeError
                    ? Icons.warning
                    : Icons.check_circle,
                color: type == CodeStrings.typeError
                    ? AppColors.white
                    : Colors.lightGreen),
            SizedBox(
              width: 8.0,
            ),
            Text(
              message,
              style: TextStyle(
                  color: type == CodeStrings.typeError
                      ? AppColors.white
                      : Colors.lightGreen),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
