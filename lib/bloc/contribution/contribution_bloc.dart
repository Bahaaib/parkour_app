import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:load/load.dart';
import 'package:parkour_app/PODO/Contribution.dart';
import 'package:parkour_app/bloc/bloc.dart';
import 'package:parkour_app/bloc/contribution/bloc.dart';
import 'package:parkour_app/provider/location_provider.dart';
import 'package:parkour_app/provider/user_provider.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:parkour_app/support/FileFactory.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:location/location.dart';

class ContributionBloc extends BLoC<ContributionEvent> {
  PublishSubject contributionSubject = PublishSubject<ContributionState>();
  final UserProvider _userProvider = GetIt.instance<UserProvider>();
  final FileFactory _fileFactory = GetIt.instance<FileFactory>();
  final LocationProvider _locationProvider = GetIt.instance<LocationProvider>();
  final StorageReference storageReference = FirebaseStorage.instance.ref();
  final List<String> _imagesUrlList = List<String>();
  double currentLatitude;
  double currentLongitude;

  @override
  void dispatch(ContributionEvent event) async {
    if (event is RequestSubmissionRequested) {
      await _submitContribution(
          title: event.title,
          description: event.description,
          address: event.address,
          imageList: event.imageList,
          latitude: event.latitude,
          longitude: event.longitude);
    }

    if (event is ContributionsRequested) {
      await _getAllContributions();
    }
  }

  Future<void> _submitContribution(
      {@required String title,
      @required String description,
      @required String address,
      List<File> imageList,
      @required double latitude,
      @required double longitude}) async {
    showLoadingDialog();

    if (imageList != null) {
      await _uploadImages(imageList);
    }

    print('Files ===> ${_imagesUrlList.length}');

    await _submitRequestToDB(
        title: title,
        description: description,
        address: address,
        latitude: latitude,
        longitude: longitude);

    contributionSubject.add(ContributionIsSubmitted());
  }

  Future<void> _uploadImages(List<File> images) async {
    final String storagePath = 'requests/ ${_userProvider.user.child_id}/';

    for (File image in images) {
      StorageUploadTask uploadTask = storageReference
          .child(storagePath + '${basename(image.path)}')
          .putFile(
              await _fileFactory.compressImageAndGetFile(image, quality: 20));
      await uploadTask.onComplete;

      print('File Uploaded');

      await storageReference
          .child(storagePath + '${basename(image.path)}')
          .getDownloadURL()
          .then((fileURL) {
        _imagesUrlList.add(fileURL);
      });
    }
  }

  Future<void> _submitRequestToDB(
      {@required String title,
      @required String description,
      @required String address,
      @required double latitude,
      @required double longitude}) async {
    Map<String, String> imagesMap = Map<String, String>();

    if (_imagesUrlList.isNotEmpty) {
      _imagesUrlList.forEach((url) {
        imagesMap.putIfAbsent('img${_imagesUrlList.indexOf(url)}', () => url);
      });
    }

    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child(CodeStrings.databaseDevInstance)
        .child(CodeStrings.contributionsDatabaseRef)
        .push();
    await ref.set({
      'user_child_id': _userProvider.user.child_id,
      'child_id': ref.key,
      'title': title,
      'description': description,
      'address': address,
      'images': imagesMap,
      'latitude': latitude,
      'longitude': longitude,
      'submission_date': DateFormat.yMMMMEEEEd().format(DateTime.now())
    });

    hideLoadingDialog();
  }

  Future<void> _getAllContributions() async {
    await _getCurrentLocation();
    Map<dynamic, dynamic> children = {};
    List<Contribution> contributions = [];
    DatabaseReference ref = FirebaseDatabase.instance.reference();

    ref
        .child(CodeStrings.databaseDevInstance)
        .child(CodeStrings.contributionsDatabaseRef)
        .once()
        .then((DataSnapshot datasnapshot) {
      children = datasnapshot.value;
      children.forEach((key, value) async {
        Contribution contribution =
            Contribution.fromFirebase(firebaseMap: value);

        if (contribution.user_child_id == _userProvider.user.child_id) {
          contribution.distanceToCurrentLocation =
              _getDistanceToCurrentLocation(
                  contribution.latitude, contribution.longitude);

          print(
              '============> DIST: ${_getDistanceToCurrentLocation(contribution.latitude, contribution.longitude)}');
          contributions.add(contribution);
        }
      });
      contributionSubject.add(ContributionsAreFetched(contributions));
    });
  }

  Future<void> _getCurrentLocation() async {
    LocationData locationData = await _locationProvider.getCurrentLocation();
    currentLatitude = locationData.latitude;
    currentLongitude = locationData.longitude;
  }

  double _getDistanceToCurrentLocation(double latitude, double longitude) {
    double radianToDecimalFactor = 0.017453292519943295;

    double a = 0.5 -
        cos((currentLatitude - latitude) * radianToDecimalFactor) / 2 +
        cos(latitude * radianToDecimalFactor) *
            cos(currentLatitude * radianToDecimalFactor) *
            (1 - cos((currentLongitude - longitude) * radianToDecimalFactor)) /
            2;

    return 12742 * asin(sqrt(a));
  }

  void dispose() {
    contributionSubject.close();
  }
}
