import 'package:rxdart/rxdart.dart';

class AppStrings {
  static PublishSubject<String> langChangedSubject = PublishSubject();
  static String currentCode = CodeStrings.englishCode;

  static Map<String, Map<String, String>> _sMap = {
    CodeStrings.englishCode: {
      'phoneHint': 'Enter your phone number',
      'phoneRequired': 'Phone number is required',
      'phoneInvalid': 'Phone number is invalid',
      'phoneLabel': 'Phone Number',
      'passwordHint': 'Type your password',
      'passwordRequired': 'Password is Required',
      'passwordInvalidError':
          'Password should be at least 8 characters that include letters, numbers and special characters',
      'passwordForgot': 'Forgot?',
      'passwordLabel': 'Password',
      'loginText': 'LOG IN',
      'newAccountText': 'Create New Account',
      'wrongCredentials': 'Wrong Credentials',
      'sendOtpText': 'SEND OTP',
      'alreadyMemberText': 'Already a member? LOGIN',
      'otpNoteText':
          'A 4 digit OTP will be sent via SMS to verify your mobile number',
      'verifyNumberTextLine1': 'Verify your',
      'verifyNumberTextLine2': 'Phone Number',
      'enterOtpText': 'Enter your OTP code here',
      'verifyText': 'VERIFY',
      'canResendText': 'You can resend code in',
      'serverErrorText': 'Server internal error',
      'resendText': 'RESEND OTP',
      'setPasswordText': 'Set Password',
      'passwordInstructions':
          'Password must be between 8 and 20 characters must include numbers, letters and symbols',
      'typePasswordHint': 'Type your password',
      'confirmPasswordLabel': 'Confirm Password',
      'confirmPasswordHint': 'Confirm your Password',
      'createAccountText': 'CREATE ACCOUNT',
      'passwordsMatchingError': 'Passwords are NOT matched',
      'otpInvalidError': 'Wrong OTP',
      'requiredDocsText': 'Required Documents',
      'frontIdText': 'Front of ID',
      'backIdText': 'Back of ID',
      'photoText': 'Photo of you',
      'scanLabel': 'Scan',
      'selfieLabel': 'Take Selfie',
      'submitLabel': 'SUBMIT'
    },
    CodeStrings.arabicCode: {},
  };

  /* Login */
  static String get phoneHint => _sMap[currentCode]["phoneHint"];

  static String get phoneRequired => _sMap[currentCode]["phoneRequired"];

  static String get phoneInvalid => _sMap[currentCode]["phoneInvalid"];

  static String get phoneLabel => _sMap[currentCode]["phoneLabel"];

  static String get passwordHint => _sMap[currentCode]["passwordHint"];

  static String get passwordRequired => _sMap[currentCode]["passwordRequired"];

  static String get passwordInvalidError =>
      _sMap[currentCode]["passwordInvalidError"];

  static String get passwordForgot => _sMap[currentCode]["passwordForgot"];

  static String get passwordLabel => _sMap[currentCode]["passwordLabel"];

  static String get loginText => _sMap[currentCode]["loginText"];

  static String get newAccountText => _sMap[currentCode]["newAccountText"];

  static String get wrongCredentials => _sMap[currentCode]["wrongCredentials"];

  /* Sign Up */
  static String get sendOtpText => _sMap[currentCode]["sendOtpText"];

  static String get alreadyMemberText =>
      _sMap[currentCode]["alreadyMemberText"];

  static String get otpNoteText => _sMap[currentCode]["otpNoteText"];

  static String get verifyNumberTextLine1 =>
      _sMap[currentCode]["verifyNumberTextLine1"];

  static String get verifyNumberTextLine2 =>
      _sMap[currentCode]["verifyNumberTextLine2"];

  static String get enterOtpText => _sMap[currentCode]["enterOtpText"];

  static String get verifyText => _sMap[currentCode]["verifyText"];

  static String get canResendText => _sMap[currentCode]["canResendText"];

  static String get serverErrorText => _sMap[currentCode]["serverErrorText"];

  static String get resendText => _sMap[currentCode]["resendText"];

  static String get passwordInstructions =>
      _sMap[currentCode]["passwordInstructions"];

  static String get setPasswordText => _sMap[currentCode]["setPasswordText"];

  static String get typePasswordHint => _sMap[currentCode]["typePasswordHint"];

  static String get confirmPasswordLabel =>
      _sMap[currentCode]["confirmPasswordLabel"];

  static String get confirmPasswordHint =>
      _sMap[currentCode]["confirmPasswordHint"];

  static String get createAccountText =>
      _sMap[currentCode]["createAccountText"];

  static String get passwordsMatchingError =>
      _sMap[currentCode]["passwordsMatchingError"];

  static String get otpInvalidError => _sMap[currentCode]["otpInvalidError"];

  static String get requiredDocsText => _sMap[currentCode]["requiredDocsText"];

  static String get frontIdText => _sMap[currentCode]["frontIdText"];

  static String get backIdText => _sMap[currentCode]["backIdText"];

  static String get photoText => _sMap[currentCode]["photoText"];

  static String get scanLabel => _sMap[currentCode]["scanLabel"];

  static String get selfieLabel => _sMap[currentCode]["selfieLabel"];

  static String get submitLabel => _sMap[currentCode]["submitLabel"];

  /* Errors */
  static String get error => _sMap[currentCode]["error"];

  static String get error_noInternet => _sMap[currentCode]["error_noInternet"];

  static String get maximum_size => _sMap[currentCode]["maximum_size"];

  static String get error_invalidEmailPassword =>
      _sMap[currentCode]["error_invalidEmailPassword"];

  static String get error_duplicateEmail =>
      _sMap[currentCode]["error_duplicateEmail"];

  static String get error_tooManyRequests =>
      _sMap[currentCode]["error_tooManyRequests"];

  static String get wrong_password => _sMap[currentCode]["wrong_password"];

  static String get status_pending => _sMap[currentCode]["status_pending"];

  static String get status_available => _sMap[currentCode]["status_available"];

  static void setCurrentLocal(String code) {
    currentCode = code;
    if (code != CodeStrings.englishCode && code != CodeStrings.arabicCode) {
      currentCode = CodeStrings.englishCode;
    }
    langChangedSubject.sink.add(currentCode);
  }
}

class CodeStrings {
  static const String englishCode = "en";
  static const String arabicCode = "ar";
  static const String english = "English";
  static const String arabic = "العربية";

  /* API Links */
  static const String LOGIN_API_PATH = 'https://staging.getchai.io/auth/login';
  static const String REGISTRATION_API_PATH =
      'https://staging.getchai.io/auth/register';
  static const String ACTIVATION_API_PATH =
      'https://staging.getchai.io/auth/activate/confirm_otp';

  static const String PASSWORD_SET_API_PATH =
      'https://staging.getchai.io/auth/activate/password';

  static const String KYC_API_PATH =
      'https://staging.getchai.io/auth/kyc/nid';

  static const String KYC_FACE_API_PATH =
      'https://staging.getchai.io/auth/kyc/face';

  static const String LOGOUT_API_PATH =
      'https://staging.getchai.io/auth/logout';

  /* Assets */
  static const String chaiLogoBlack = 'assets/images/Chai-Black.png';

  /* General */
  static const String confirmPasswordTag = 'confirm';
  static const String originalPasswordTag = 'original';
  static const List<String> docsTags = ['front', 'back', 'selfie'];

  static final List<String> docsTextList = [
    AppStrings.frontIdText,
    AppStrings.backIdText,
    AppStrings.photoText
  ];

  static final List<String> docsButtonLabelsList = [
    AppStrings.scanLabel,
    AppStrings.scanLabel,
    AppStrings.selfieLabel
  ];
}
