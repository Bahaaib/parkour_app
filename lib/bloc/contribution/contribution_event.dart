import 'dart:io';

import 'package:flutter/cupertino.dart';

abstract class ContributionEvent {}

class RequestSubmissionRequested extends ContributionEvent {
  final String title;
  final String description;
  final String address;
  final List<File> imageList;
  final double latitude;
  final double longitude;

  RequestSubmissionRequested(
      {@required this.title,
      @required this.description,
      @required this.address,
      this.imageList,
      @required this.latitude,
      @required this.longitude});
}

class ContributionsRequested extends ContributionEvent {}

class ContributionSelected extends ContributionEvent {
  final double latitude;
  final double longitude;

  ContributionSelected(this.latitude, this.longitude);
}
