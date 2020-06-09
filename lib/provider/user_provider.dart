import 'package:parkour_app/PODO/AuthUser.dart';


class UserProvider {
  AuthUser _user;

  AuthUser get user => _user;

  set user(AuthUser value) {
    _user = value;
  }
}
