import 'dart:io';

import 'package:flutter/cupertino.dart';

abstract class ContributionEvent {}

class ContributionSubmissionRequested extends ContributionEvent {
  final String title;
  final String description;
  final String address;
  final List<File> imageList;
  final double latitude;
  final double longitude;

  ContributionSubmissionRequested(
      {@required this.title,
      @required this.description,
      @required this.address,
      this.imageList,
      @required this.latitude,
      @required this.longitude});
}
