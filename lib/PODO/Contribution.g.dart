// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Contribution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contribution _$ContributionFromJson(Map<String, dynamic> json) {
  return Contribution(
    json['user_child_id'] as String,
    json['child_id'] as String,
    json['title'] as String,
    json['description'] as String,
    json['address'] as String,
    json['images'] as List,
    (json['latitude'] as num)?.toDouble(),
    (json['longitude'] as num)?.toDouble(),
    json['submission_date'] as String,
  )
    ..imagesMap = json['imagesMap'] as Map<String, dynamic>
    ..distanceToCurrentLocation =
        (json['distanceToCurrentLocation'] as num)?.toDouble();
}

Map<String, dynamic> _$ContributionToJson(Contribution instance) =>
    <String, dynamic>{
      'user_child_id': instance.user_child_id,
      'child_id': instance.child_id,
      'title': instance.title,
      'description': instance.description,
      'address': instance.address,
      'imagesMap': instance.imagesMap,
      'images': instance.images,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'submission_date': instance.submission_date,
      'distanceToCurrentLocation': instance.distanceToCurrentLocation,
    };
