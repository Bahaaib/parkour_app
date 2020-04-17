// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:parkour_app/UI/Auth/login_page.dart';
import 'package:parkour_app/UI/Auth/signup_page.dart';

class MainRouter {
  static const loginPage = '/';
  static const signUpPage = '/sign-up-page';
  static GlobalKey<NavigatorState> get navigatorKey =>
      getNavigatorKey<MainRouter>();
  static NavigatorState get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
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
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
