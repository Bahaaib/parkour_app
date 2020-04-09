abstract class AuthEvent {}

class UserLoginRequested extends AuthEvent {
  final String phoneNumber;
  final String password;

  UserLoginRequested(this.phoneNumber, this.password);
}

class OTPCodeRequested extends AuthEvent {
  final String phoneNumber;

  OTPCodeRequested(this.phoneNumber);
}

class OTPResendRequested extends AuthEvent {}

class OTPVerificationRequested extends AuthEvent {
  final String otpCode;

  OTPVerificationRequested(this.otpCode);
}

class PasswordSetRequested extends AuthEvent {
  final String newPassword;
  final String confirmationPassword;

  PasswordSetRequested(this.newPassword, this.confirmationPassword);
}

class UserLogoutRequested extends AuthEvent{}
