import 'package:flutter/material.dart';

import 'app_colors.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.iconMuted,
    required this.navActive,
    required this.navInactive,
    required this.chipBackground,
    required this.chipText,
    required this.divider,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.cardOverlay,
  });

  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color iconMuted;
  final Color navActive;
  final Color navInactive;
  final Color chipBackground;
  final Color chipText;
  final Color divider;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color cardOverlay;

  static const light = AppThemeColors(
    textPrimary: AppColors.textPrimaryLight,
    textSecondary: AppColors.textSecondaryLight,
    textHint: AppColors.textHintLight,
    iconMuted: AppColors.textSecondaryLight,
    navActive: AppColors.primary,
    navInactive: AppColors.navInactiveLight,
    chipBackground: AppColors.chipLight,
    chipText: AppColors.textPrimaryLight,
    divider: AppColors.dividerLight,
    shimmerBase: AppColors.shimmerBaseLight,
    shimmerHighlight: AppColors.shimmerHighlightLight,
    cardOverlay: AppColors.cardOverlayLight,
  );

  static const dark = AppThemeColors(
    textPrimary: AppColors.textPrimaryDark,
    textSecondary: AppColors.textSecondaryDark,
    textHint: AppColors.textHintDark,
    iconMuted: AppColors.textSecondaryDark,
    navActive: AppColors.primary,
    navInactive: AppColors.navInactiveDark,
    chipBackground: AppColors.chipDark,
    chipText: AppColors.textPrimaryDark,
    divider: AppColors.dividerDark,
    shimmerBase: AppColors.shimmerBaseDark,
    shimmerHighlight: AppColors.shimmerHighlightDark,
    cardOverlay: AppColors.cardOverlayDark,
  );

  @override
  AppThemeColors copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? iconMuted,
    Color? navActive,
    Color? navInactive,
    Color? chipBackground,
    Color? chipText,
    Color? divider,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? cardOverlay,
  }) {
    return AppThemeColors(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      iconMuted: iconMuted ?? this.iconMuted,
      navActive: navActive ?? this.navActive,
      navInactive: navInactive ?? this.navInactive,
      chipBackground: chipBackground ?? this.chipBackground,
      chipText: chipText ?? this.chipText,
      divider: divider ?? this.divider,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      cardOverlay: cardOverlay ?? this.cardOverlay,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      iconMuted: Color.lerp(iconMuted, other.iconMuted, t)!,
      navActive: Color.lerp(navActive, other.navActive, t)!,
      navInactive: Color.lerp(navInactive, other.navInactive, t)!,
      chipBackground: Color.lerp(chipBackground, other.chipBackground, t)!,
      chipText: Color.lerp(chipText, other.chipText, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight:
          Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      cardOverlay: Color.lerp(cardOverlay, other.cardOverlay, t)!,
    );
  }
}

extension AppThemeColorsX on BuildContext {
  AppThemeColors get appThemeColors =>
      Theme.of(this).extension<AppThemeColors>() ?? AppThemeColors.light;

  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;
}
