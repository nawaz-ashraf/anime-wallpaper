import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static const boxName = 'animeverse_box';
  static const _keyOnboarding = 'onboardingSeen';
  static const _keyDarkMode = 'isDarkMode';
  static const _keyFavorites = 'favoriteIds';
  static const _keyRecentSearches = 'recentSearches';

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(boxName);
  }

  bool get isOnboardingSeen =>
      _box.get(_keyOnboarding, defaultValue: false) as bool;

  Future<void> setOnboardingSeen(bool value) async {
    await _box.put(_keyOnboarding, value);
  }

  bool get isDarkMode => _box.get(_keyDarkMode, defaultValue: true) as bool;

  Future<void> setDarkMode(bool value) async {
    await _box.put(_keyDarkMode, value);
  }

  List<int> get favoriteIds =>
      List<int>.from(_box.get(_keyFavorites, defaultValue: <int>[]));

  Future<void> setFavoriteIds(List<int> ids) async {
    await _box.put(_keyFavorites, ids);
  }

  List<String> get recentSearches =>
      List<String>.from(_box.get(_keyRecentSearches, defaultValue: <String>[]));

  Future<void> addRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final current = recentSearches;
    current.removeWhere((item) => item.toLowerCase() == trimmed.toLowerCase());
    current.insert(0, trimmed);
    if (current.length > 10) {
      current.removeRange(10, current.length);
    }
    await _box.put(_keyRecentSearches, current);
  }

  Future<void> clearRecentSearches() async {
    await _box.put(_keyRecentSearches, <String>[]);
  }
}
