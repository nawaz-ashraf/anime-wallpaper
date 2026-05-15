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
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/logo/app_logo.png',
                  width: 36,
                  height: 36,
                ),
              ),
              const SizedBox(width: 14),
              Text('Settings',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 18),
          
          // Theme Toggle
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
          
          // General Settings
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
          
          const SizedBox(height: 24),
          Text('Legal',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          // Copyright Section
          _ExpandableInfoCard(
            title: 'Copyright Notice',
            icon: Icons.copyright,
            content:
                'All wallpapers used in this application belong to their respective owners. This app is created for entertainment and personalization purposes only. If you are the rightful owner of any content and want it removed, please contact us and the content will be removed immediately.',
            gradient: const [Color(0xFF7C3AED), Color(0xFF5B2EFF)],
          ),
          const SizedBox(height: 16),

          // Disclaimer Section
          _ExpandableInfoCard(
            title: 'Disclaimer',
            icon: Icons.gavel,
            content:
                'AnimeVerse 4K does not claim ownership of copyrighted anime artworks or wallpapers. All trademarks, logos, and images belong to their respective creators and studios. Wallpapers are collected from publicly available sources or user-provided assets for fan entertainment purposes only.',
            gradient: const [Color(0xFFFF3D00), Color(0xFFEF233C)],
          ),
          
          const SizedBox(height: 100), // Bottom padding
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
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/logo/app_logo.png',
                      width: 28,
                      height: 28,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
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

class _ExpandableInfoCard extends StatefulWidget {
  const _ExpandableInfoCard({
    required this.title,
    required this.icon,
    required this.content,
    required this.gradient,
  });

  final String title;
  final IconData icon;
  final String content;
  final List<Color> gradient;

  @override
  State<_ExpandableInfoCard> createState() => _ExpandableInfoCardState();
}

class _ExpandableInfoCardState extends State<_ExpandableInfoCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final tc = context.appThemeColors;
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: GlassContainer(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: widget.gradient),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: widget.gradient.first.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(widget.icon, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(Icons.expand_more, color: tc.iconMuted),
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  widget.content,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: tc.textSecondary,
                        height: 1.5,
                      ),
                ),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}
