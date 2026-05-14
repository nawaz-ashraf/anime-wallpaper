import 'package:flutter/material.dart';

import '../core/constants/category_data.dart';
import '../themes/app_colors.dart';
import '../themes/app_theme_extension.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    this.thumbnailPath,
  });

  final CategoryMeta category;
  final bool isSelected;
  final VoidCallback onTap;
  final String? thumbnailPath;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkTheme;
    final textColor = isSelected
        ? Colors.white
        : (isDark ? Colors.white70 : context.appThemeColors.textPrimary);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? category.gradient
                : category.gradient
                    .map((color) => color.withOpacity(0.35))
                    .toList(),
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: (isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black))
                .withOpacity(isSelected ? 0.4 : 0.12),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: category.gradient.first.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular thumbnail if available
            if (thumbnailPath != null) ...[
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                  image: DecorationImage(
                    image: AssetImage(thumbnailPath!),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ] else ...[
              Icon(category.icon, color: textColor, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              category.name,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
