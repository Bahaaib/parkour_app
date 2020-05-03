import 'package:rxdart/rxdart.dart';

class AppStrings {
  static PublishSubject<String> langChangedSubject = PublishSubject();
  static String currentCode = CodeStrings.englishCode;

  static Map<String, Map<String, String>> _sMap = {
    CodeStrings.englishCode: {
      'mailHint': 'Enter your E-mail Address',
      'mailRequired': 'E-mail Address is required',
      'mailInvalid': 'Invalid E-mail Address',
      'mailLabel': 'E-mail Address',
      'passwordHint': 'Type your password',
      'passwordRequired': 'Password is Required',
      'passwordInvalidError': 'Password should be at least 8 characters',
      'passwordForgot': 'Forgot?',
      'passwordLabel': 'Password',
      'loginText': 'LOG IN',
      'newAccountText': 'Create New Account',
      'wrongCredentials': 'Wrong Credentials',
      'alreadyMemberText': 'Already a member? LOGIN',
      'serverErrorText': 'Server internal error',
      'signupLabel': 'SIGN UP',
      'resendText': 'RESEND OTP',
      'setPasswordText': 'Set Password',
      'passwordInstructions':
          'Password must be between 8 and 20 characters must include numbers, letters and symbols',
      'typePasswordHint': 'Type your password',
      'confirmPasswordLabel': 'Confirm Password',
      'confirmPasswordHint': 'Confirm your Password',
      'createAccountText': 'CREATE ACCOUNT',
      'passwordsMatchingError': 'Passwords are NOT matched',
      'userExistsError': 'This account is already registered',
      'signedSuccessMessage': 'Your account has been created successfully',
      'resetPasswordLabel': 'RESET PASSWORD',
      'resetSuccessMessage':
          'An e-mail with reset details has been sent to you',
      'noMailError': 'This E-mail is not registered on our systems',
      'account': 'Account',
      'personalInfo': 'Personal Information',
      'changePassword': 'Change Password',
      'myContributions': 'My Contributions',
      'general': 'General',
      'privacyPolicy': 'Privacy Policy',
      'termsAndConditions': 'Terms and Conditions',
      'logout': 'Logout',
      'cancelLabel': 'Cancel',
      'logoutText': 'Are you sure you want to logout?',
      'profileText': 'Personal info',
      'generalInfoText': 'General info',
      'socialAccountsText': 'Social accounts',
      'usernameLabel': 'Username',
      'addressLabel': 'Address',
      'usernameHint': 'Type your username',
      'addressHint': 'Type your Address (City, Province,..)',
      'whatsappHint': 'Type your What\'s App Number',
      'facebookHint': 'Type your Facebook URL',
      'twitterHint': 'Type your Twitter URL',
      'saveButtonLabel': 'SAVE',
      'addPlaceText': 'Submit a new place',
      'titleHint': 'Type the place title',
      'descHint': 'Type general info about the place',
      'placeAddressHint': 'Type the place address (Street, Zip code,..etc)',
      'titleLabel': 'Title',
      'descLabel': 'Description',
      'imagesLabel': 'Place images (optional)',
      'submitButtonLabel': 'SUBMIT',
      'fieldRequiredError': 'Field is required',
      'contributionConfirmationMessage':
          'Thanks for your contribution \n Our team will check it carefully very soon',
      'contributionsText': 'My Contributions',
      'aboutText': 'About',
      'dummyDescriptionText':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'dummyAddressText': 'Ansgarstr. 4, Wallenhorst, 49134',
      'galleryLabel': 'Gallery',
      'oldPasswordLabel': 'Old Password',
      'newPasswordLabel': 'New Password',
      'resetLabel': 'Reset Password',
      'oldPasswordHint': 'Type your old password',
      'newPasswordHint': 'Type your new password',
      'passwordChangedMessage': 'Password has been changed successfully'
    },
    CodeStrings.germanCode: {},
  };

  static String get passwordChangedMessage =>
      _sMap[currentCode]["passwordChangedMessage"];

  static String get oldPasswordHint => _sMap[currentCode]["oldPasswordHint"];

  static String get newPasswordHint => _sMap[currentCode]["newPasswordHint"];

  static String get resetLabel => _sMap[currentCode]["resetLabel"];

  static String get oldPasswordLabel => _sMap[currentCode]["oldPasswordLabel"];

  static String get newPasswordLabel => _sMap[currentCode]["newPasswordLabel"];

  static String get galleryLabel => _sMap[currentCode]["galleryLabel"];

  static String get dummyAddressText => _sMap[currentCode]["dummyAddressText"];

  static String get dummyDescriptionText =>
      _sMap[currentCode]["dummyDescriptionText"];

  static String get aboutText => _sMap[currentCode]["aboutText"];

  static String get contributionsText =>
      _sMap[currentCode]["contributionsText"];

  static String get contributionConfirmationMessage =>
      _sMap[currentCode]["contributionConfirmationMessage"];

  static String get addPlaceText => _sMap[currentCode]["addPlaceText"];

  static String get titleHint => _sMap[currentCode]["titleHint"];

  static String get descHint => _sMap[currentCode]["descHint"];

  static String get placeAddressHint => _sMap[currentCode]["placeAddressHint"];

  static String get titleLabel => _sMap[currentCode]["titleLabel"];

  static String get descLabel => _sMap[currentCode]["descLabel"];

  static String get imagesLabel => _sMap[currentCode]["imagesLabel"];

  static String get submitButtonLabel =>
      _sMap[currentCode]["submitButtonLabel"];

  static String get fieldRequiredError =>
      _sMap[currentCode]["fieldRequiredError"];

  /* Profile */
  static String get profileText => _sMap[currentCode]["profileText"];

  static String get generalInfoText => _sMap[currentCode]["generalInfoText"];

  static String get socialAccountsText =>
      _sMap[currentCode]["socialAccountsText"];

  static String get usernameLabel => _sMap[currentCode]["usernameLabel"];

  static String get addressLabel => _sMap[currentCode]["addressLabel"];

  static String get usernameHint => _sMap[currentCode]["usernameHint"];

  static String get addressHint => _sMap[currentCode]["addressHint"];

  static String get whatsappHint => _sMap[currentCode]["whatsappHint"];

  static String get facebookHint => _sMap[currentCode]["facebookHint"];

  static String get twitterHint => _sMap[currentCode]["twitterHint"];

  static String get saveButtonLabel => _sMap[currentCode]["saveButtonLabel"];

  /* Home Page */
  static String get logout => _sMap[currentCode]["logout"];

  static String get logoutText => _sMap[currentCode]["logoutText"];

  static String get cancelLabel => _sMap[currentCode]["cancelLabel"];

  static String get general => _sMap[currentCode]["general"];

  static String get privacyPolicy => _sMap[currentCode]["privacyPolicy"];

  static String get termsAndConditions =>
      _sMap[currentCode]["termsAndConditions"];

  static String get account => _sMap[currentCode]["account"];

  static String get personalInfo => _sMap[currentCode]["personalInfo"];

  static String get changePassword => _sMap[currentCode]["changePassword"];

  static String get myContributions => _sMap[currentCode]["myContributions"];

  /* Login */
  static String get mailHint => _sMap[currentCode]["mailHint"];

  static String get mailRequired => _sMap[currentCode]["mailRequired"];

  static String get mailInvalid => _sMap[currentCode]["mailInvalid"];

  static String get mailLabel => _sMap[currentCode]["mailLabel"];

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

  static String get alreadyMemberText =>
      _sMap[currentCode]["alreadyMemberText"];

  static String get serverErrorText => _sMap[currentCode]["serverErrorText"];

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

  static String get requiredDocsText => _sMap[currentCode]["requiredDocsText"];

  static String get signupLabel => _sMap[currentCode]["signupLabel"];

  static String get userExistsError => _sMap[currentCode]["userExistsError"];

  static String get signedSuccessMessage =>
      _sMap[currentCode]["signedSuccessMessage"];

  static String get resetPasswordLabel =>
      _sMap[currentCode]["resetPasswordLabel"];

  static String get noMailError => _sMap[currentCode]["noMailError"];

  static String get resetSuccessMessage =>
      _sMap[currentCode]["resetSuccessMessage"];

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
    if (code != CodeStrings.englishCode && code != CodeStrings.germanCode) {
      currentCode = CodeStrings.englishCode;
    }
    langChangedSubject.sink.add(currentCode);
  }
}

class CodeStrings {
  static const String englishCode = "en";
  static const String germanCode = "de";
  static const String english = "English";
  static const String german = "Deutsch";

  /* Assets */
  static const String appLogo = 'assets/parkour.png';
  static const String googleIcon = 'assets/Google.png';
  static const String facebookIcon = 'assets/facebook.png';
  static const String twitterSmallIcon = 'assets/ic_twitter.png';
  static const String facebookSmallIcon = 'assets/ic_facebook.png';
  static const String whatsappSmallIcon = 'assets/ic_whatsapp.png';
  static const String checkMarkIcon = 'assets/ic_check.png';

  /* General */
  static const String confirmPasswordTag = 'confirm';
  static const String originalPasswordTag = 'original';
  static const String userSharedPrefKEY = "user_key";
  static const String databaseDevInstance = "dev";
  static const String databaseProductionInstance = "production";
  static const String usersDatabaseRef = "users";
  static const String requestsDatabaseRef = "requests";
  static const String resultSignupSuccess = "signup_sucess";
  static const String resultPasswordResetSuccess = "pass_reset_sucess";
  static const String resultPasswordChangeSuccess = "pass_change_sucess";
  static const String typeSuccess = 'success';
  static const String typeError = 'error';
  static const String twitterTag = 'twitter_url';
  static const String facebookTag = 'facebook_url';
  static const String whatsappTag = 'Type your What\'s App Number';
  static const String addressTag = 'address';
  static const String usernameTag = 'username';
  static const String titleTag = 'title';
  static const String descriptionTag = 'description';
  static const String oldPasswordTag = 'old';
  static const String newPasswordTag = 'new';
}
