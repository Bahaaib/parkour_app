// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Contributor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contributor _$ContributorFromJson(Map<String, dynamic> json) {
  return Contributor(
    json['id'] as String,
    json['child_id'] as String,
    json['username'] as String,
    json['address'] as String,
    json['email_address'] as String,
    json['whatsapp_number'] as String,
    json['facebook_url'] as String,
    json['twitter_url'] as String,
  );
}

Map<String, dynamic> _$ContributorToJson(Contributor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'child_id': instance.child_id,
      'username': instance.username,
      'address': instance.address,
      'email_address': instance.email_address,
      'whatsapp_number': instance.whatsapp_number,
      'facebook_url': instance.facebook_url,
      'twitter_url': instance.twitter_url,
    };
