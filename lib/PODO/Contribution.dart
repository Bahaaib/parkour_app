import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Contribution.g.dart';

@JsonSerializable()
class Contribution {
  String user_child_id;
  String child_id;
  String title;
  String description;
  String address;
  Map<dynamic, dynamic> imagesMap;
  List<dynamic> images;
  double latitude;
  double longitude;
  String submission_date;
  double distanceToCurrentLocation;

  Contribution.fromFirebase({@required Map<dynamic, dynamic> firebaseMap}) {
    this.user_child_id = firebaseMap['user_child_id'];
    this.child_id = firebaseMap['child_id'];
    this.title = firebaseMap['title'];
    this.description = firebaseMap['description'];
    this.address = firebaseMap['address'];
    this.imagesMap = firebaseMap['images'];
    this.images = imagesMap?.values?.toList();
    this.latitude = firebaseMap['latitude'];
    this.longitude = firebaseMap['longitude'];
    this.submission_date = firebaseMap['submission_date'];
  }

  Contribution(
      this.user_child_id,
      this.child_id,
      this.title,
      this.description,
      this.address,
      this.images,
      this.latitude,
      this.longitude,
      this.submission_date);

  factory Contribution.fromJson(Map<String, dynamic> json) =>
      _$ContributionFromJson(json);

  Map<String, dynamic> toJson() => _$ContributionToJson(this);
}
