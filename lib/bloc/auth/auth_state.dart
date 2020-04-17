import 'package:parkour_app/PODO/AuthUser.dart';

abstract class AuthState {}

class UserIsLoggedIn extends AuthState {
  final AuthUser authUser;

  UserIsLoggedIn(this.authUser);
}

class UserIsLoggedout extends AuthState {}
