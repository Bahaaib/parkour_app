import 'package:auto_route/auto_route_annotations.dart';
import 'package:parkour_app/UI/Auth/login_page.dart';
import 'package:parkour_app/UI/Auth/password_change_page.dart';
import 'package:parkour_app/UI/Auth/reset_password_page.dart';
import 'package:parkour_app/UI/Auth/signup_page.dart';
import 'package:parkour_app/UI/Contribution/Contribution_details_page.dart';
import 'package:parkour_app/UI/Contribution/confirmation_page.dart';
import 'package:parkour_app/UI/Contribution/contributions_page.dart';
import 'package:parkour_app/UI/Contribution/image_zoom_page.dart';
import 'package:parkour_app/UI/Contribution/place_submission.dart';
import 'package:parkour_app/UI/Profile/profile_page.dart';
import 'package:parkour_app/UI/home_page.dart';
import 'package:parkour_app/UI/splash_screen.dart';

@autoRouter
class $MainRouter {
  @initial
  SplashScreen splashScreen;
  HomePage homePage;
  LoginPage loginPage;
  SignUpPage signUpPage;
  PasswordResetPage passwordResetPage;
  PasswordChangePage passwordChangePage;
  ProfilePage profilePage;
  PlaceSubmissionPage placeSubmissionPage;
  ConfirmationPage confirmationPage;
  ContributionsPage contributionsPage;
  ContributionDetailsPage contributionDetailsPage;
  ImageZoomPage imageZoomPage;
}
