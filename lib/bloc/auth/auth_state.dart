import 'package:parkour_app/PODO/AuthUser.dart';

abstract class AuthState {}

class UserIsLoggedIn extends AuthState {
  final AuthUser authUser;

  UserIsLoggedIn(this.authUser);
}

class OTPCodeIsSent extends AuthState {
  final String token;

  OTPCodeIsSent(this.token);
}

///DO NOT OVERRIDE IT WITH THE ABOVE STATE :|
class OTPCodeIsResent extends AuthState {
  final String token;

  OTPCodeIsResent(this.token);
}

class OTPCodeIsVerified extends AuthState {
  final bool isValid;

  OTPCodeIsVerified(this.isValid);
}

class PasswordSetAndAccountIsCreated extends AuthState{}

class UserIsLoggedout extends AuthState{}
