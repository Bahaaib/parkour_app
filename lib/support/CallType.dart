import 'package:parkour_app/PODO/AuthUser.dart';

abstract class CallType {
  Future<AuthUser> call(AuthUser authuser);
}