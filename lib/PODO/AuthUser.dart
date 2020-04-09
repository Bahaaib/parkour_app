import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'AuthUser.g.dart';

@JsonSerializable()
class AuthUser {
  int id;
  String username;
  String display_name;
  String email_address;
  String created_at;
  bool is_phone_verified;
  String language;
  String kyc_status_text;
  String referral_promo_code;
  String token;

  AuthUser.empty();

  AuthUser(this.id, this.username, this.display_name, this.email_address,
      this.created_at, this.is_phone_verified, this.language,
      this.kyc_status_text, this.referral_promo_code, this.token);

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserToJson(this);
}
