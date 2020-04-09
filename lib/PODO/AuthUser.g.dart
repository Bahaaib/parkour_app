// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) {
  return AuthUser(
    json['id'] as int,
    json['username'] as String,
    json['display_name'] as String,
    json['email_address'] as String,
    json['created_at'] as String,
    json['is_phone_verified'] as bool,
    json['language'] as String,
    json['kyc_status_text'] as String,
    json['referral_promo_code'] as String,
    json['token'] as String,
  );
}

Map<String, dynamic> _$AuthUserToJson(AuthUser instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'display_name': instance.display_name,
      'email_address': instance.email_address,
      'created_at': instance.created_at,
      'is_phone_verified': instance.is_phone_verified,
      'language': instance.language,
      'kyc_status_text': instance.kyc_status_text,
      'referral_promo_code': instance.referral_promo_code,
      'token': instance.token,
    };
