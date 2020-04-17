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

class UserLogoutRequested extends AuthEvent {}
