import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'AuthUser.g.dart';

@JsonSerializable()
class AuthUser {
  String id;
  String username;
  String email_address;

  AuthUser.firebaseUser({@required Map<dynamic, dynamic> firebaseMap}) {
    this.id = firebaseMap['id'];
    this.username = firebaseMap['username'];
    this.email_address = firebaseMap['email_address'];
  }

  AuthUser(this.id, this.username, this.email_address);

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserToJson(this);
}
