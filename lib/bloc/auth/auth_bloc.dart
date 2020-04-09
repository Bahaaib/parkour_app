import 'dart:convert';

import 'package:parkour_app/PODO/AuthUser.dart';
import 'package:parkour_app/bloc/auth/bloc.dart';
import 'package:parkour_app/bloc/bloc.dart';
import 'package:parkour_app/provider/user_provider.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:parkour_app/support/NetworkProvider/APIManager.dart';
import 'package:get_it/get_it.dart';
import 'package:load/load.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc extends BLoC<AuthEvent> {
  UserProvider _userProvider = GetIt.instance<UserProvider>();
  APIManager _apiManager = GetIt.instance<APIManager>();
  PublishSubject authSubject = PublishSubject<AuthState>();

  AuthUser _user;
  String _token;
  String _phoneNumber;

  @override
  void dispatch(AuthEvent event) async {
    if (event is UserLoginRequested) {
      await _loginWithPhoneAndPassword(event.phoneNumber, event.password);
    }

    if (event is OTPCodeRequested) {
      _setPhoneNumber(event.phoneNumber);
      await _validatePhoneNumber(event.phoneNumber);
    }

    if (event is OTPVerificationRequested) {
      _validateOTP(event.otpCode);
    }

    if (event is OTPResendRequested) {
      _resendOTPCode();
    }

    if (event is PasswordSetRequested) {
      _setNewPassword(event.newPassword, event.confirmationPassword);
    }

    if(event is UserLogoutRequested){
      await _logout();
    }
  }

  Future<void> _loginWithPhoneAndPassword(
      String phoneNumber, String password) async {
    showLoadingDialog();

    ///[API] sets the [phoneNumber] as the user [Username]
    ///in Login request
    Map<String, dynamic> _credentialsMap = {
      'username': _getCleanString(phoneNumber),
      'password': _getCleanString(password)
    };
    _apiManager.setEncodedBodyFromMap(map: _credentialsMap);
    await _apiManager
        .post(
      CodeStrings.LOGIN_API_PATH,
    )
        .then((response) {
      if (response.statusCode == 200) {
        _user = AuthUser.fromJson(jsonDecode(response.body)['account']);
        _token = jsonDecode(response.body)['token'];
        _user.token = _token;
        _userProvider.user = _user;
        authSubject.add(UserIsLoggedIn(_user));
        hideLoadingDialog();
      } else {
        authSubject.add(UserIsLoggedIn(null));
        hideLoadingDialog();
      }
    });
  }

  Future<void> _validatePhoneNumber(String number) async {
    showLoadingDialog();

    Map<String, dynamic> _registrationMap = {
      'phone_number': _getCleanString(number),
      'language': AppStrings.currentCode.toUpperCase()
    };

    _apiManager.setEncodedBodyFromMap(map: _registrationMap);

    await _apiManager
        .post(
      CodeStrings.REGISTRATION_API_PATH,
    )
        .then((response) {
      if (response.statusCode == 200) {
        _token = jsonDecode(response.body)['token'];
        _user.token = _token;
        _userProvider.user = _user;
        authSubject.add(OTPCodeIsSent(_token));
        hideLoadingDialog();
      } else {
        authSubject.add(OTPCodeIsSent(null));
        hideLoadingDialog();
      }
    });
  }

  Future<void> _validateOTP(String otpCode) async {
    showLoadingDialog();

    Map<String, dynamic> _otpVerificationMap = {
      'one_time_pin': _getCleanString(otpCode),
      'activation_token': _token
    };

    _apiManager.setEncodedBodyFromMap(map: _otpVerificationMap);

    await _apiManager
        .post(
      CodeStrings.ACTIVATION_API_PATH,
    )
        .then((response) {
      if (response.statusCode == 200) {
        authSubject.add(OTPCodeIsVerified(true));
        hideLoadingDialog();
      } else {
        authSubject.add(OTPCodeIsVerified(false));
        hideLoadingDialog();
      }
    });
  }

  Future<void> _resendOTPCode() async {
    showLoadingDialog();
    Map<String, dynamic> _registrationMap = {
      'phone_number': _phoneNumber,
      'language': AppStrings.currentCode.toUpperCase()
    };

    _apiManager.setEncodedBodyFromMap(map: _registrationMap);

    await _apiManager
        .post(
      CodeStrings.REGISTRATION_API_PATH,
    )
        .then((response) {
      if (response.statusCode == 200) {
        _token = jsonDecode(response.body)['token'];
        _user.token = _token;
        _userProvider.user = _user;
        authSubject.add(OTPCodeIsResent(_token));
        hideLoadingDialog();
      } else {
        authSubject.add(OTPCodeIsResent(null));
        hideLoadingDialog();
      }
    });
  }

  Future<void> _setNewPassword(
      String newPassword, String confirmationPassword) async {
    showLoadingDialog();
    Map<String, dynamic> _setPasswordMap = {
      'activation_token': _token,
      'new_password': newPassword,
      'confirm_password': confirmationPassword
    };

    _apiManager.setEncodedBodyFromMap(map: _setPasswordMap);

    await _apiManager
        .post(
      CodeStrings.PASSWORD_SET_API_PATH,
    )
        .then((response) {
      if (response.statusCode == 200) {
        hideLoadingDialog();
      } else {
        hideLoadingDialog();
      }
    });
  }

  Future<void> _logout() async {
    showLoadingDialog();

    _apiManager.setHeaders(isTokenRequired: true, token: _token);
    _apiManager.setEncodedBodyFromMap(map: null);
    await _apiManager
        .post(
      CodeStrings.LOGOUT_API_PATH,
    )
        .then((response) {
      if (response.statusCode == 200) {
        authSubject.add(UserIsLoggedout());
        hideLoadingDialog();
      } else {
        hideLoadingDialog();
      }
    });
  }

  void _setPhoneNumber(String number) {
    if (number != null) {
      _phoneNumber = number;
    }
  }

  ///Extracts the white spaces out of string
  String _getCleanString(String value) {
    return value.trim();
  }

  void dispose() {
    authSubject.close();
  }
}
