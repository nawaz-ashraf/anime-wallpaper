import 'dart:math';

import 'package:get/get.dart';

import '../models/wallpaper.dart';
import '../repositories/wallpaper_repository.dart';

class WallpaperController extends GetxController {
  WallpaperController(this._repository);

  final WallpaperRepository _repository;

  final RxList<WallpaperModel> wallpapers = <WallpaperModel>[].obs;
  final RxList<WallpaperModel> trending = <WallpaperModel>[].obs;
  final RxList<WallpaperModel> categoryWallpapers = <WallpaperModel>[].obs;
  final RxList<WallpaperModel> searchResults = <WallpaperModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString selectedCategory = 'Anime'.obs;

  @override
  void onInit() {
    loadWallpapers();
    super.onInit();
  }

  void loadWallpapers() {
    isLoading.value = true;

    wallpapers.assignAll(_repository.allWallpapers);
    trending.assignAll(_repository.trending);
    setCategory(selectedCategory.value);

    isLoading.value = false;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    // Shuffle category wallpapers for fresh layout each time
    final list = List<WallpaperModel>.from(_repository.getByCategory(category));
    list.shuffle(Random());
    categoryWallpapers.assignAll(list);
  }

  void refreshTrending() {
    _repository.refreshTrending();
    trending.assignAll(_repository.trending);
  }

  void search(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      searchResults.clear();
      return;
    }
    searchResults.assignAll(_repository.search(query));
  }

  void clearSearch() {
    searchResults.clear();
  }

  List<WallpaperModel> getSimilar(WallpaperModel wallpaper) {
    return _repository.getSimilar(wallpaper);
  }

  String? getCategoryThumbnail(String category) {
    return _repository.getCategoryThumbnail(category);
  }

  int getCategoryCount(String category) {
    return _repository.getCategoryCount(category);
  }
}
