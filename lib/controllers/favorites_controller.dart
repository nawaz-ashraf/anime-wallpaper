import 'package:get/get.dart';

import '../services/local_storage_service.dart';

class FavoritesController extends GetxController {
  FavoritesController(this._storage);

  final LocalStorageService _storage;

  final RxSet<int> favoriteIds = <int>{}.obs;

  @override
  void onInit() {
    favoriteIds.addAll(_storage.favoriteIds);
    super.onInit();
  }

  bool isFavorite(int id) => favoriteIds.contains(id);

  Future<void> toggleFavorite(int id) async {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
    } else {
      favoriteIds.add(id);
    }
    await _storage.setFavoriteIds(favoriteIds.toList());
  }

  Future<void> clearFavorites() async {
    favoriteIds.clear();
    await _storage.setFavoriteIds(<int>[]);
  }
}
