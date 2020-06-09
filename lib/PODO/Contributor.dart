import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Contributor.g.dart';

@JsonSerializable()
class Contributor {
  String id;
  String child_id;
  String username;
  String address;
  String email_address;
  String whatsapp_number;
  String facebook_url;
  String twitter_url;


  Contributor.fromFirebase({@required Map<dynamic, dynamic> firebaseMap}) {
    this.id = firebaseMap['id'];
    this.child_id = firebaseMap['child_id'];
    this.username = firebaseMap['username'];
    this.address = firebaseMap['address'];
    this.email_address = firebaseMap['email_address'];
    this.whatsapp_number = firebaseMap['whatsapp_number'];
    this.facebook_url = firebaseMap['facebook_url'];
    this.twitter_url = firebaseMap['twitter_url'];
  }


  Contributor(this.id, this.child_id, this.username, this.address,
      this.email_address, this.whatsapp_number, this.facebook_url,
      this.twitter_url);

  factory Contributor.fromJson(Map<String, dynamic> json) =>
      _$ContributorFromJson(json);

  Map<String, dynamic> toJson() => _$ContributorToJson(this);
}
