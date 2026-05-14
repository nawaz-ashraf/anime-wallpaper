import 'dart:ui';

import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_theme_extension.dart';

class GlassBottomNav extends StatelessWidget {
  const GlassBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkTheme;
    final themeColors = context.appThemeColors;
    final background = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final items = const [
      _NavItem(icon: Icons.auto_awesome_mosaic_outlined, label: 'Home'),
      _NavItem(icon: Icons.grid_view_rounded, label: 'Categories'),
      _NavItem(icon: Icons.favorite_border, label: 'Favorites'),
      _NavItem(icon: Icons.search_rounded, label: 'Search'),
      _NavItem(icon: Icons.settings_rounded, label: 'Settings'),
    ];
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: background.withOpacity(isDark ? 0.6 : 0.75),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.08),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isActive = currentIndex == index;
                final activeColor = themeColors.navActive;
                final inactiveColor = themeColors.navInactive;
                return Expanded(
                  child: InkWell(
                    onTap: () => onTap(index),
                    borderRadius: BorderRadius.circular(18),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? activeColor.withOpacity(isDark ? 0.22 : 0.16)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isActive
                              ? activeColor.withOpacity(0.35)
                              : Colors.transparent,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            height: 3,
                            width: isActive ? 22 : 10,
                            decoration: BoxDecoration(
                              color:
                                  isActive ? activeColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Icon(
                            item.icon,
                            size: 22,
                            color: isActive ? activeColor : inactiveColor,
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              item.label,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color:
                                        isActive ? activeColor : inactiveColor,
                                    fontWeight: isActive
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
