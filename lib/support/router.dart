import 'package:auto_route/auto_route_annotations.dart';
import 'package:parkour_app/UI/Auth/login_page.dart';
import 'package:parkour_app/UI/Auth/reset_password_page.dart';
import 'package:parkour_app/UI/Auth/signup_page.dart';
import 'package:parkour_app/UI/home_page.dart';
import 'package:parkour_app/UI/splash_screen.dart';

@autoRouter
class $MainRouter {
  @initial
  SplashScreen splashScreen;
  HomePage homePage;
  LoginPage loginPage;
  SignUpPage signUpPage;
  PasswordResetScreen passwordResetScreen;
}
