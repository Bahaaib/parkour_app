import 'package:parkour_app/PODO/AuthUser.dart';

abstract class AuthMethod {
  String serviceName; // ex. google, facebook, github

  Future<AuthUser> auth();
}