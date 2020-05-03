import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parkour_app/bloc/auth/auth_bloc.dart';
import 'package:parkour_app/bloc/auth/bloc.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:parkour_app/support/router.gr.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _mail;
  bool _isError = false;
  String _result;

  final AuthBloc _authBloc = GetIt.instance<AuthBloc>();
  StreamSubscription _streamSubscription;

  @override
  void initState() {
    _streamSubscription = _authBloc.authSubject.listen((receivedState) {
      if (receivedState is PasswordIsReset) {
        if (receivedState.isSuccessful) {
          MainRouter.navigator.pushNamedAndRemoveUntil(
              MainRouter.loginPage, (_) => false,
              arguments: {'result': CodeStrings.resultPasswordResetSuccess});
        }else{
          setState(() {
            _isError = true;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      _showSnackBar(AppStrings.noMailError, CodeStrings.typeError);
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
                  _buildTextLabel(AppStrings.resetPasswordLabel,
                      fontSize: 30.0, topMargin: 80.0),
                  _buildCredentialsForm(),
                  _buildResetButton(),
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
        ],
      ),
    );
  }

  Widget _buildTextLabel(String label,
      {double fontSize = 20.0, double topMargin = 40.0}) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 20, end: 20, top: topMargin),
      child: Text(
        label,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
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
      ),
    );
  }

  bool _isValidEmail(String mail) {
    return EmailValidator.validate(mail);
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
          AppStrings.resetPasswordLabel,
          style: TextStyle(
              color: AppColors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _authBloc.dispatch(UserPasswordResetRequested(_mail));
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
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
