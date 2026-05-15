import 'dart:math';

import '../models/wallpaper.dart';

/// Registry entry for one category folder on disk.
class _CategoryEntry {
  const _CategoryEntry({
    required this.folder,
    required this.filePrefix,
    required this.count,
    required this.displayName,
    this.isAnime = false,
  });

  final String folder;
  final String filePrefix;
  final int count;
  final String displayName;
  final bool isAnime;
}

class WallpaperRepository {
  WallpaperRepository() {
    _buildWallpapers();
    shuffleAll(); // Shuffle on every app launch
  }

  // ──────────────────────────────────────────────
  // Registry — maps every folder to its file info
  // ──────────────────────────────────────────────
  static const List<_CategoryEntry> _registry = [
    _CategoryEntry(folder: 'anime', filePrefix: 'anime', count: 38, displayName: 'Anime', isAnime: true),
    _CategoryEntry(folder: 'naruto', filePrefix: 'naruto', count: 61, displayName: 'Naruto', isAnime: true),
    _CategoryEntry(folder: 'one_piece', filePrefix: 'onepiece', count: 42, displayName: 'One Piece', isAnime: true),
    _CategoryEntry(folder: 'demon_slayer', filePrefix: 'demonslayer', count: 38, displayName: 'Demon Slayer', isAnime: true),
    _CategoryEntry(folder: 'solo_leveling', filePrefix: 'sololeveling', count: 15, displayName: 'Solo Leveling', isAnime: true),
    _CategoryEntry(folder: 'jjk', filePrefix: 'jjk', count: 22, displayName: 'Jujutsu Kaisen', isAnime: true),
    _CategoryEntry(folder: 'attack_on_titan', filePrefix: 'aot', count: 14, displayName: 'Attack on Titan', isAnime: true),
    _CategoryEntry(folder: 'chainsaw_man', filePrefix: 'chainsawman', count: 9, displayName: 'Chainsaw Man', isAnime: true),
    _CategoryEntry(folder: 'dragon_ball', filePrefix: 'dragonball', count: 50, displayName: 'Dragon Ball', isAnime: true),
    _CategoryEntry(folder: 'cyberpunk', filePrefix: 'cyberpunk', count: 7, displayName: 'Cyberpunk', isAnime: true),
    _CategoryEntry(folder: 'gaming', filePrefix: 'gaming', count: 9, displayName: 'Gaming'),
    _CategoryEntry(folder: 'cars', filePrefix: 'cars', count: 19, displayName: 'Cars'),
    _CategoryEntry(folder: 'nature', filePrefix: 'nature', count: 24, displayName: 'Nature'),
    _CategoryEntry(folder: 'amoled', filePrefix: 'amoled', count: 14, displayName: 'AMOLED'),
    _CategoryEntry(folder: 'neon', filePrefix: 'neon', count: 9, displayName: 'Neon'),
    _CategoryEntry(folder: 'abstract', filePrefix: 'abstract', count: 8, displayName: 'Abstract'),
    _CategoryEntry(folder: 'minimal', filePrefix: 'minimal', count: 6, displayName: 'Minimal'),
  ];

  final List<WallpaperModel> _allWallpapers = [];
  final List<WallpaperModel> _trending = [];
  final Map<String, List<WallpaperModel>> _byCategory = {};
  final List<String> _categoryNames = [];

  // ──────────────────────────────────────────────
  // Build wallpaper list from registry
  // ──────────────────────────────────────────────
  void _buildWallpapers() {
    final random = Random();
    int globalId = 0;

    for (final entry in _registry) {
      final categoryList = <WallpaperModel>[];

      for (int i = 1; i <= entry.count; i++) {
        final path = 'assets/wallpapers/${entry.folder}/${entry.filePrefix}_$i.jpeg';
        final title = _generateTitle(entry.displayName, i);

        // Mark some as trending: higher chance for anime categories
        final trendingChance = entry.isAnime ? 0.15 : 0.08;
        final isTrending = random.nextDouble() < trendingChance;

        final wallpaper = WallpaperModel(
          id: globalId++,
          title: title,
          category: entry.displayName,
          imagePath: path,
          isTrending: isTrending,
          resolution: '1080x1920',
        );

        categoryList.add(wallpaper);
        _allWallpapers.add(wallpaper);
      }

      _byCategory[entry.displayName] = categoryList;
      _categoryNames.add(entry.displayName);
    }

    // Build trending list — prioritize anime, shuffle, cap at 15
    _buildTrendingList();
  }

  void _buildTrendingList() {
    final random = Random();
    _trending.clear();

    final trendingCandidates = _allWallpapers.where((w) => w.isTrending).toList();
    if (trendingCandidates.length < 10) {
      // If not enough were randomly selected, pick more from anime categories
      final animeWallpapers = _allWallpapers
          .where((w) => !w.isTrending)
          .where((w) => _registry.any((r) => r.displayName == w.category && r.isAnime))
          .toList();
      animeWallpapers.shuffle(random);
      trendingCandidates.addAll(animeWallpapers.take(15 - trendingCandidates.length));
    }
    trendingCandidates.shuffle(random);
    _trending.addAll(trendingCandidates.take(15));
  }

  String _generateTitle(String category, int index) {
    final suffixes = [
      'Epic', 'Cinematic', 'Ultra HD', '4K', 'Dark', 'Vibrant',
      'Legendary', 'Shadow', 'Neon', 'Fire', 'Storm', 'Rise',
      'Glory', 'Battle', 'Spirit', 'Mystic', 'Power', 'Fury',
    ];
    final suffix = suffixes[(index - 1) % suffixes.length];
    return '$category $suffix ${((index - 1) ~/ suffixes.length) + 1}';
  }

  // ──────────────────────────────────────────────
  // Shuffle System — call on every app launch
  // ──────────────────────────────────────────────
  void shuffleAll() {
    final random = Random();

    // Shuffle the master wallpaper list
    _allWallpapers.shuffle(random);

    // Shuffle each category's wallpapers independently
    for (final entry in _byCategory.entries) {
      entry.value.shuffle(random);
    }

    // Rebuild trending with fresh randomization
    _buildTrendingList();
  }

  // ──────────────────────────────────────────────
  // Public API
  // ──────────────────────────────────────────────
  List<WallpaperModel> get allWallpapers => List.unmodifiable(_allWallpapers);

  List<WallpaperModel> get trending => List.unmodifiable(_trending);

  List<String> get categoryNames => List.unmodifiable(_categoryNames);

  List<WallpaperModel> getByCategory(String category) {
    return _byCategory[category] ?? [];
  }

  /// Returns a random wallpaper thumbnail from the category (shuffled each launch).
  String? getCategoryThumbnail(String category) {
    final list = _byCategory[category];
    if (list == null || list.isEmpty) return null;
    return list.first.imagePath;
  }

  int getCategoryCount(String category) {
    return _byCategory[category]?.length ?? 0;
  }

  List<WallpaperModel> search(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return [];
    return _allWallpapers
        .where((w) =>
            w.title.toLowerCase().contains(normalized) ||
            w.category.toLowerCase().contains(normalized))
        .toList();
  }

  List<WallpaperModel> getSimilar(WallpaperModel wallpaper, {int limit = 6}) {
    final list = _allWallpapers
        .where((w) => w.category == wallpaper.category && w.id != wallpaper.id)
        .toList();
    list.shuffle(Random());
    return list.take(limit).toList();
  }

  /// Refresh trending with a new random seed.
  void refreshTrending() {
    _buildTrendingList();
  }
}
