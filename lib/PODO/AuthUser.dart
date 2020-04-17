import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'AuthUser.g.dart';

@JsonSerializable()
class AuthUser {
  String id;
  String username;
  String email_address;

  AuthUser.cached(
      {@required String id,
      @required String username,
      @required email_address}) {
    this.id = id;
    this.username = username;
    this.email_address = email_address;
  }

  AuthUser(this.id, this.username, this.email_address);

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserToJson(this);
}
