import 'package:parkour_app/PODO/AuthUser.dart';
import 'package:parkour_app/provider/shared_prefrence_provider.dart';
import 'package:parkour_app/resources/strings.dart';

class UserProvider {
  AuthUser _user;

  AuthUser get user => _user;

  set user(AuthUser value) {
    _user = value;
  }
}
