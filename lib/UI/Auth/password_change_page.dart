import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parkour_app/bloc/auth/auth_bloc.dart';
import 'package:parkour_app/bloc/auth/auth_event.dart';
import 'package:parkour_app/bloc/auth/auth_state.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:parkour_app/support/router.gr.dart';

class PasswordChangePage extends StatefulWidget {
  @override
  _PasswordChangePageState createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final AuthBloc _authBloc = GetIt.instance<AuthBloc>();

  final FocusNode _newPasswordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _isObscure = true;
  String _newPassword;
  String _confirmationPassword;
  StreamSubscription _streamSubscription;

  @override
  void initState() {
    _streamSubscription = _authBloc.authSubject.listen((receivedState) {
      if (receivedState is PasswordIsChanged) {
        MainRouter.navigator.pushNamedAndRemoveUntil(
            MainRouter.homePage, (_) => false,
            arguments: {'result': CodeStrings.resultPasswordChangeSuccess});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: AppColors.black,
              size: 35.0,
            ),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: AlignmentDirectional.center,
                margin: EdgeInsetsDirectional.only(
                    top: 20.0, start: 20.0, end: 20.0),
                child: Text(
                  AppStrings.changePassword,
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsetsDirectional.only(
                    top: 30.0, start: 20.0, end: 20.0),
                child: Text(
                  AppStrings.passwordInstructions,
                  style:
                      TextStyle(color: AppColors.offGrey, fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ),
              _buildPasswordForm(),
              _buildResetButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTextLabel(AppStrings.newPasswordLabel),
          _buildPasswordField(
              tag: CodeStrings.newPasswordTag,
              hint: AppStrings.newPasswordHint,
              fieldNode: _newPasswordNode,
              destinationNode: _confirmPasswordNode),
          _buildTextLabel(AppStrings.confirmPasswordLabel),
          _buildPasswordField(
              tag: CodeStrings.confirmPasswordTag,
              hint: AppStrings.confirmPasswordHint,
              fieldNode: _confirmPasswordNode),
        ],
      ),
    );
  }

  Widget _buildTextLabel(String label) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 20, end: 20, top: 30),
      child: Text(
        label,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPasswordField(
      {@required String hint,
      @required tag,
      @required FocusNode fieldNode,
      FocusNode destinationNode}) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 20, end: 20, top: 10),
      child: TextFormField(
        focusNode: fieldNode,
        validator: (password) {
          if (password.isEmpty) {
            return AppStrings.passwordRequired;
          }

          if (_isValidPassword(password)) {
            _setPasswordByTag(password, tag);
          } else {
            return AppStrings.passwordInvalidError;
          }

          if (tag == CodeStrings.confirmPasswordTag &&
              !_arePasswordsMatched()) {
            return AppStrings.passwordsMatchingError;
          }
          return null;
        },
        obscureText: _isObscure,
        onFieldSubmitted: (_) {
          if (destinationNode != null) {
            FocusScope.of(context).requestFocus(destinationNode);
          }
        },
        decoration: InputDecoration(
          errorMaxLines: 2,
          hintText: hint,
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
        ),
      ),
    );
  }

  void _setPasswordByTag(String password, String tag) {
    if (tag == CodeStrings.confirmPasswordTag) {
      _confirmationPassword = password;
    } else if (tag == CodeStrings.newPasswordTag) {
      _newPassword = password;
    }
  }

  bool _arePasswordsMatched() {
    if (_newPassword == _confirmationPassword) {
      return true;
    } else {
      return false;
    }
  }

  bool _isValidPassword(String password) {
    if (password.length < 8) {
      return false;
    }
    return true;
  }

  Widget _buildResetButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70.0,
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      margin: EdgeInsetsDirectional.only(start: 20, end: 20, top: 30),
      child: RaisedButton(
        color: AppColors.primaryColor,
        child: Text(
          AppStrings.changePassword.toUpperCase(),
          style: TextStyle(
              color: AppColors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            ///TODO: dispatch password change event
            _authBloc.dispatch(UserPasswordChangeRequested(_newPassword));
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
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
