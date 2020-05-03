// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:parkour_app/UI/splash_screen.dart';
import 'package:parkour_app/UI/home_page.dart';
import 'package:parkour_app/UI/Auth/login_page.dart';
import 'package:parkour_app/UI/Auth/signup_page.dart';
import 'package:parkour_app/UI/Auth/reset_password_page.dart';
import 'package:parkour_app/UI/Auth/password_change_page.dart';
import 'package:parkour_app/UI/Profile/profile_page.dart';
import 'package:parkour_app/UI/Contribution/place_submission.dart';
import 'package:parkour_app/UI/Contribution/confirmation_page.dart';
import 'package:parkour_app/UI/Contribution/contributions_page.dart';
import 'package:parkour_app/UI/Contribution/Contribution_details_page.dart';
import 'package:parkour_app/UI/Contribution/image_zoom_page.dart';

class MainRouter {
  static const splashScreen = '/';
  static const homePage = '/home-page';
  static const loginPage = '/login-page';
  static const signUpPage = '/sign-up-page';
  static const passwordResetPage = '/password-reset-page';
  static const passwordChangePage = '/password-change-page';
  static const profilePage = '/profile-page';
  static const placeSubmissionPage = '/place-submission-page';
  static const confirmationPage = '/confirmation-page';
  static const contributionsPage = '/contributions-page';
  static const contributionDetailsPage = '/contribution-details-page';
  static const imageZoomPage = '/image-zoom-page';
  static GlobalKey<NavigatorState> get navigatorKey =>
      getNavigatorKey<MainRouter>();
  static NavigatorState get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case MainRouter.splashScreen:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
          settings: settings,
        );
      case MainRouter.homePage:
        return MaterialPageRoute(
          builder: (_) => HomePage(),
          settings: settings,
        );
      case MainRouter.loginPage:
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
          settings: settings,
        );
      case MainRouter.signUpPage:
        return MaterialPageRoute(
          builder: (_) => SignUpPage(),
          settings: settings,
        );
      case MainRouter.passwordResetPage:
        return MaterialPageRoute(
          builder: (_) => PasswordResetPage(),
          settings: settings,
        );
      case MainRouter.passwordChangePage:
        return MaterialPageRoute(
          builder: (_) => PasswordChangePage(),
          settings: settings,
        );
      case MainRouter.profilePage:
        return MaterialPageRoute(
          builder: (_) => ProfilePage(),
          settings: settings,
        );
      case MainRouter.placeSubmissionPage:
        return MaterialPageRoute(
          builder: (_) => PlaceSubmissionPage(),
          settings: settings,
        );
      case MainRouter.confirmationPage:
        return MaterialPageRoute(
          builder: (_) => ConfirmationPage(),
          settings: settings,
        );
      case MainRouter.contributionsPage:
        return MaterialPageRoute(
          builder: (_) => ContributionsPage(),
          settings: settings,
        );
      case MainRouter.contributionDetailsPage:
        return MaterialPageRoute(
          builder: (_) => ContributionDetailsPage(),
          settings: settings,
        );
      case MainRouter.imageZoomPage:
        return MaterialPageRoute(
          builder: (_) => ImageZoomPage(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
