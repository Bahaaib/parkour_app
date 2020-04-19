import 'package:firebase_auth/firebase_auth.dart';
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

class CurrentUserIs extends AuthState {
  final FirebaseUser user;

  CurrentUserIs(this.user);
}

class PasswordIsReset extends AuthState {
  final bool isSuccessful;

  PasswordIsReset(this.isSuccessful);
}

class UserIsLoggedOut extends AuthState {}
