import 'package:parkour_app/PODO/AuthUser.dart';

abstract class AuthState {}

class UserIsLoggedIn extends AuthState {
  final AuthUser authUser;

  UserIsLoggedIn(this.authUser);
}

class UserIsRegisteredWithEmailAndPassword extends AuthState {
  final bool isSuccessful;

  UserIsRegisteredWithEmailAndPassword(this.isSuccessful);
}

class UserIsLoggedOut extends AuthState {}
