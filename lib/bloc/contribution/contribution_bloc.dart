import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:load/load.dart';
import 'package:parkour_app/bloc/auth/auth_state.dart';
import 'package:parkour_app/bloc/bloc.dart';
import 'package:parkour_app/bloc/contribution/bloc.dart';
import 'package:parkour_app/provider/user_provider.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:parkour_app/support/FileFactory.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ContributionBloc extends BLoC<ContributionEvent> {
  PublishSubject contributionSubject = PublishSubject<ContributionState>();
  final UserProvider _userProvider = GetIt.instance<UserProvider>();
  final FileFactory _fileFactory = GetIt.instance<FileFactory>();
  final StorageReference storageReference = FirebaseStorage.instance.ref();
  final List<String> _imagesUrlList = List<String>();

  @override
  void dispatch(ContributionEvent event) async {
    if (event is ContributionSubmissionRequested) {
      await _submitContribution(
          title: event.title,
          description: event.description,
          address: event.address,
          imageList: event.imageList,
          latitude: event.latitude,
          longitude: event.longitude);
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
        .child(CodeStrings.requestsDatabaseRef)
        .push();
    await ref.set({
      'user_child_id': _userProvider.user.child_id,
      'child_id': ref.key,
      'title': title,
      'description': description,
      'address': address,
      'images': imagesMap,
      'latitude': latitude,
      'longitude': longitude
    });

    hideLoadingDialog();
  }

  void dispose() {
    contributionSubject.close();
  }
}
