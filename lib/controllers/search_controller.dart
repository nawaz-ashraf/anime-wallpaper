import 'package:get/get.dart';

import '../services/local_storage_service.dart';

class WallpaperSearchController extends GetxController {
  WallpaperSearchController(this._storage);

  final LocalStorageService _storage;

  final RxString query = ''.obs;
  final RxList<String> recentSearches = <String>[].obs;

  @override
  void onInit() {
    recentSearches.assignAll(_storage.recentSearches);
    super.onInit();
  }

  Future<void> submitSearch(String value) async {
    await _storage.addRecentSearch(value);
    recentSearches.assignAll(_storage.recentSearches);
  }

  Future<void> clearRecents() async {
    await _storage.clearRecentSearches();
    recentSearches.clear();
  }
}
