import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_theme_extension.dart';

class PremiumSearchBar extends StatelessWidget {
  const PremiumSearchBar(
      {super.key,
      required this.controller,
      required this.onChanged,
      required this.onSubmitted,
      this.onClear,
      this.hintText = 'Search anime, genre, vibe...'});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback? onClear;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final themeColors = context.appThemeColors;
    final isDark = context.isDarkTheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.25),
            AppColors.secondary.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: themeColors.divider.withOpacity(isDark ? 0.2 : 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: themeColors.textPrimary,
            ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: themeColors.textHint,
              ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: themeColors.iconMuted,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: themeColors.iconMuted,
                  ),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                    onClear?.call();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
