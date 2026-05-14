import 'package:flutter/material.dart';

class CategoryMeta {
  const CategoryMeta({
    required this.name,
    required this.folderName,
    required this.icon,
    required this.gradient,
    required this.subtitle,
    this.isAnime = false,
  });

  final String name;
  final String folderName;
  final IconData icon;
  final List<Color> gradient;
  final String subtitle;
  final bool isAnime;
}

class CategoryData {
  static const List<CategoryMeta> categories = [
    // ── Anime Categories (first) ──
    CategoryMeta(
      name: 'Anime',
      folderName: 'anime',
      icon: Icons.auto_awesome,
      gradient: [Color(0xFF7C3AED), Color(0xFF0A0A0F)],
      subtitle: 'Mixed Anime Art',
      isAnime: true,
    ),
    CategoryMeta(
      name: 'Naruto',
      folderName: 'naruto',
      icon: Icons.flash_on,
      gradient: [Color(0xFFFF6B00), Color(0xFF1A1A1A)],
      subtitle: 'Leaf Village Legends',
      isAnime: true,
    ),
    CategoryMeta(
      name: 'One Piece',
      folderName: 'one_piece',
      icon: Icons.sailing,
      gradient: [Color(0xFFFFC107), Color(0xFF0B1320)],
      subtitle: 'Pirate Era Odyssey',
      isAnime: true,
    ),
    CategoryMeta(
      name: 'Demon Slayer',
      folderName: 'demon_slayer',
      icon: Icons.local_fire_department,
      gradient: [Color(0xFFEF233C), Color(0xFF1B1B1B)],
      subtitle: 'Breathing Styles',
      isAnime: true,
    ),
    CategoryMeta(
      name: 'Solo Leveling',
      folderName: 'solo_leveling',
      icon: Icons.auto_awesome,
      gradient: [Color(0xFF6D28D9), Color(0xFF090A0F)],
      subtitle: 'Shadow Monarch',
      isAnime: true,
    ),
    CategoryMeta(
      name: 'Jujutsu Kaisen',
      folderName: 'jjk',
      icon: Icons.bolt,
      gradient: [Color(0xFF00C2FF), Color(0xFF0A0A0F)],
      subtitle: 'Cursed Energy',
      isAnime: true,
    ),
    CategoryMeta(
      name: 'Attack on Titan',
      folderName: 'attack_on_titan',
      icon: Icons.shield,
      gradient: [Color(0xFF9B7E46), Color(0xFF0E0E0E)],
      subtitle: 'Walls & Titans',
      isAnime: true,
    ),
    CategoryMeta(
      name: 'Chainsaw Man',
      folderName: 'chainsaw_man',
      icon: Icons.hardware,
      gradient: [Color(0xFFFF3D00), Color(0xFF111111)],
      subtitle: 'Devil Hunter',
      isAnime: true,
    ),
    CategoryMeta(
      name: 'Dragon Ball',
      folderName: 'dragon_ball',
      icon: Icons.public,
      gradient: [Color(0xFFFF8F00), Color(0xFF1C1A28)],
      subtitle: 'Saiyan Power',
      isAnime: true,
    ),
    CategoryMeta(
      name: 'Cyberpunk',
      folderName: 'cyberpunk',
      icon: Icons.blur_on,
      gradient: [Color(0xFF9D4EDD), Color(0xFF1A0828)],
      subtitle: 'Neon Future',
      isAnime: true,
    ),

    // ── Other Categories ──
    CategoryMeta(
      name: 'Gaming',
      folderName: 'gaming',
      icon: Icons.sports_esports,
      gradient: [Color(0xFF5B2EFF), Color(0xFF130B2B)],
      subtitle: 'Next-Gen',
    ),
    CategoryMeta(
      name: 'Cars',
      folderName: 'cars',
      icon: Icons.directions_car_filled,
      gradient: [Color(0xFF00C9FF), Color(0xFF005B8F)],
      subtitle: '4K Speed',
    ),
    CategoryMeta(
      name: 'Nature',
      folderName: 'nature',
      icon: Icons.park,
      gradient: [Color(0xFF00C853), Color(0xFF0B2D1A)],
      subtitle: 'Serene Landscapes',
    ),
    CategoryMeta(
      name: 'AMOLED',
      folderName: 'amoled',
      icon: Icons.nightlight,
      gradient: [Color(0xFF00E5FF), Color(0xFF000000)],
      subtitle: 'True Black',
    ),
    CategoryMeta(
      name: 'Neon',
      folderName: 'neon',
      icon: Icons.light_mode,
      gradient: [Color(0xFF00F5D4), Color(0xFF120A25)],
      subtitle: 'Electric Glow',
    ),
    CategoryMeta(
      name: 'Abstract',
      folderName: 'abstract',
      icon: Icons.blur_circular,
      gradient: [Color(0xFFFF4081), Color(0xFF120014)],
      subtitle: 'Fluid Forms',
    ),
    CategoryMeta(
      name: 'Minimal',
      folderName: 'minimal',
      icon: Icons.crop_free,
      gradient: [Color(0xFFECEFF1), Color(0xFF4A4A4A)],
      subtitle: 'Clean & Calm',
    ),
  ];

  static CategoryMeta? byName(String name) {
    try {
      return categories.firstWhere((category) => category.name == name);
    } catch (_) {
      return null;
    }
  }

  static List<String> get animeCategories =>
      categories.where((c) => c.isAnime).map((c) => c.name).toList();

  static List<String> get otherCategories =>
      categories.where((c) => !c.isAnime).map((c) => c.name).toList();

  static List<String> get allCategoryNames =>
      categories.map((c) => c.name).toList();
}
