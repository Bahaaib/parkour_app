import 'dart:io';

import 'package:parkour_app/PODO/LocalError.dart';
import 'package:parkour_app/bloc/ErrorBloc.dart';
import 'package:parkour_app/resources/errors.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:load/load.dart';

import 'NetworkConnectivityChecker.dart';
//Function that handles all basic internet requests
//by handles its errors and show Loading...
Future<void> netFunc(Function fun, {bool showLoading = true}) async {
  if (showLoading)
    Future.delayed(Duration(milliseconds: 100), () {
      showLoadingDialog(tapDismiss: false);
    });

  ErrorBloc.clear();
  try {
    bool isConnected = await NetworkConnectivityChecker.isConnected();
    if (!isConnected) {
      throw AppErrors.en4;
    }

    await fun();
  } catch (e) {
    if (e is LocalError) {
      ErrorBloc.push(e);
    } else {
      ErrorBloc.push(LocalError(0, e.toString(), "", "Server!"));
    }
  } finally {
    if (showLoading) {
      Future.delayed(Duration(milliseconds: 100),(){
        hideLoadingDialog();
      });
    }
  }
}

class AppUtils {
  int countWords(String string) {
    String currentAnswer = string.trim();

    int counter = 0;
    for (int i = 0; i < currentAnswer.length; i++) {
      if ((currentAnswer[i].trim() != "" && counter == 0) ||
          (currentAnswer[i].trim() != "" && currentAnswer[i - 1] == " ")) {
        counter++;
      }
    }
    return counter;
  }

  Future<File> compressToFit(File file) async {
    while (file != null && bToMb(file.lengthSync()) > 2) {
      await FlutterImageCompress.compressAndGetFile(
          file.absolute.path, file.absolute.path,
          quality: 40);
      print("FILE LENGTH: ${file.lengthSync()}");
    }
    return file;
  }

  double bToMb(int byte) {
    return (byte / (1000 * 1000));
  }

  bool validEmail(String value) {
    if (RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }
}
