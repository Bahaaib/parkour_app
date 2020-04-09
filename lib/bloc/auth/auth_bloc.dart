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
    }



    if(event is UserLogoutRequested){
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
