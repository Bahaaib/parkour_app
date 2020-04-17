// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) {
  return AuthUser(
    json['id'] as String,
    json['username'] as String,
    json['email_address'] as String,
  );
}

Map<String, dynamic> _$AuthUserToJson(AuthUser instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email_address': instance.email_address,
    };
