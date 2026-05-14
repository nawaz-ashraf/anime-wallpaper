import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  Future<bool> requestPermission() async {
    final statuses = await [
      Permission.photos,
      Permission.storage,
    ].request();

    return statuses.values.any((status) => status.isGranted);
  }

  /// Save a bundled asset image to the device gallery.
  Future<bool> saveAssetToGallery({
    required String assetPath,
    required String fileName,
    required void Function(double progress) onProgress,
  }) async {
    final hasPermission = await requestPermission();
    if (!hasPermission) {
      return false;
    }

    onProgress(0.1);

    // Load the asset bytes from the bundle
    final ByteData byteData = await rootBundle.load(assetPath);
    final Uint8List bytes = byteData.buffer.asUint8List();

    onProgress(0.5);

    // Write to temp file
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    onProgress(0.8);

    // Save to gallery
    final result = await ImageGallerySaver.saveFile(filePath, name: fileName);
    final isSuccess = result['isSuccess'] == true;

    // Clean up temp file
    if (await file.exists()) {
      await file.delete();
    }

    onProgress(1.0);

    return isSuccess;
  }
}
