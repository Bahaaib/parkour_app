import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class FileFactory {
  String _tempDirectory;

  Future<File> compressImageAndGetFile(File file,
      {@required int quality}) async {
    _tempDirectory = (await getTemporaryDirectory()).path;
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      _tempDirectory + DateTime.now().toString() + '.jpeg',
      quality: quality,
    );

    print(file.lengthSync() / (1024 * 1024));
    print(result.lengthSync() / (1024 * 1024));

    return result;
  }
}
