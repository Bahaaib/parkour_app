abstract class AuthEvent {}

class LoginWithGoogleRequested extends AuthEvent {}

class LoginWithEmailAndPasswordRequested extends AuthEvent {
  final String email;
  final String password;

  LoginWithEmailAndPasswordRequested(this.email, this.password);
}

class SignUpWithEmailAndPasswordRequested extends AuthEvent {
  final String email;
  final String password;

  SignUpWithEmailAndPasswordRequested(this.email, this.password);
}

class UserCurrentStatusRequested extends AuthEvent {}

class UserPasswordResetRequested extends AuthEvent {
  final String email;

  UserPasswordResetRequested(this.email);
}

class UserPasswordChangeRequested extends AuthEvent {
  final String password;

  UserPasswordChangeRequested(this.password);
}

class UserDataByCachedIdRequested extends AuthEvent {}

class UserLogoutRequested extends AuthEvent {}
