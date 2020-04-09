import 'package:auto_route/auto_route_annotations.dart';
import 'package:parkour_app/UI/login_page.dart';

@autoRouter
class $MainRouter {
  @initial
  LoginPage loginPage;
}
