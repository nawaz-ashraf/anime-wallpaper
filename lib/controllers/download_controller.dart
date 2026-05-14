import 'package:get/get.dart';

import '../models/wallpaper.dart';
import '../services/download_service.dart';

class DownloadController extends GetxController {
  DownloadController(this._service);

  final DownloadService _service;

  final RxDouble progress = 0.0.obs;
  final RxBool isDownloading = false.obs;

  Future<bool> downloadWallpaper(WallpaperModel wallpaper) async {
    isDownloading.value = true;
    progress.value = 0.0;

    final success = await _service.saveAssetToGallery(
      assetPath: wallpaper.imagePath,
      fileName: 'animeverse_${wallpaper.id}.jpg',
      onProgress: (value) => progress.value = value,
    );

    isDownloading.value = false;
    return success;
  }
}
