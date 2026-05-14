import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/favorites_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../themes/app_theme_extension.dart';
import '../../widgets/glass_container.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final favoritesController = Get.find<FavoritesController>();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Settings',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 18),
          GlassContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dark Mode',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('AMOLED black with neon accents',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.appThemeColors.textSecondary)),
                  ],
                ),
                Obx(() => Switch.adaptive(
                      value: themeController.isDarkMode.value,
                      onChanged: (_) => themeController.toggleTheme(),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassContainer(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.delete_outline,
                  title: 'Clear favorites',
                  subtitle: 'Remove all saved wallpapers',
                  onTap: () {
                    favoritesController.clearFavorites();
                    Get.snackbar('Favorites cleared',
                        'All favorites have been removed.',
                        backgroundColor: Colors.black87,
                        colorText: Colors.white);
                  },
                ),
                Divider(height: 24, color: context.appThemeColors.divider),
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: 'About AnimeVerse 4K',
                  subtitle: 'Premium anime wallpaper experience',
                  onTap: () => _showInfoSheet(context,
                      title: 'AnimeVerse 4K',
                      body:
                          'A curated collection of cinematic wallpapers with an anime-first aesthetic. All wallpapers are bundled locally for instant access.'),
                ),
                Divider(height: 24, color: context.appThemeColors.divider),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy policy',
                  subtitle: 'We respect your data',
                  onTap: () => _showInfoSheet(context,
                      title: 'Privacy',
                      body:
                          'AnimeVerse 4K stores your favorites and settings locally on your device. No accounts or tracking.'),
                ),
                Divider(height: 24, color: context.appThemeColors.divider),
                _SettingsTile(
                  icon: Icons.star_border,
                  title: 'Rate the app',
                  subtitle: 'Support our studio',
                  onTap: () => _showInfoSheet(context,
                      title: 'Thanks for the love',
                      body:
                          'Your rating helps AnimeVerse 4K reach more fans.'),
                ),
                Divider(height: 24, color: context.appThemeColors.divider),
                const _SettingsTile(
                  icon: Icons.verified,
                  title: 'Version',
                  subtitle: '1.0.0 (AnimeVerse 4K)',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoSheet(BuildContext context,
      {required String title, required String body}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Text(body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.appThemeColors.textSecondary)),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile(
      {required this.icon,
      required this.title,
      required this.subtitle,
      this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkTheme;
    final tc = context.appThemeColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: tc.iconMuted, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: tc.textSecondary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: tc.iconMuted),
          ],
        ),
      ),
    );
  }
}
