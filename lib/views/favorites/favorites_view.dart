import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../controllers/favorites_controller.dart';
import '../../controllers/wallpaper_controller.dart';
import '../../routes/app_routes.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_theme_extension.dart';
import '../../widgets/wallpaper_card.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesController = Get.find<FavoritesController>();
    final wallpaperController = Get.find<WallpaperController>();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Favorites',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Obx(
                  () => favoritesController.favoriteIds.isNotEmpty
                      ? TextButton.icon(
                          onPressed: () => favoritesController.clearFavorites(),
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Clear All'),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () {
                final favoriteWallpapers = wallpaperController.wallpapers
                    .where((wallpaper) =>
                        favoritesController.isFavorite(wallpaper.id))
                    .toList();

                if (favoriteWallpapers.isEmpty) {
                  final themeColors = context.appThemeColors;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.neonPink.withOpacity(0.1),
                          ),
                          child: Icon(Icons.favorite_border,
                              size: 56, color: AppColors.neonPink.withOpacity(0.5)),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No favorites yet',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: themeColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the heart to save your best picks',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: themeColors.textHint,
                                  ),
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MasonryGridView.count(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 700 ? 3 : 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    itemCount: favoriteWallpapers.length,
                    itemBuilder: (context, index) {
                      final wallpaper = favoriteWallpapers[index];
                      return WallpaperCard(
                        wallpaper: wallpaper,
                        onTap: () => Get.toNamed(AppRoutes.details,
                            arguments: wallpaper),
                        height: index.isEven ? 260 : 300,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
