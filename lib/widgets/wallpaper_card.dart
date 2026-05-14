import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../controllers/favorites_controller.dart';
import '../models/wallpaper.dart';
import '../themes/app_colors.dart';

class WallpaperCard extends StatelessWidget {
  const WallpaperCard({
    super.key,
    required this.wallpaper,
    required this.onTap,
    this.showTitle = true,
    this.height = 260,
  });

  final WallpaperModel wallpaper;
  final VoidCallback onTap;
  final bool showTitle;
  final double height;

  @override
  Widget build(BuildContext context) {
    final favoritesController = Get.find<FavoritesController>();
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'wallpaper_${wallpaper.id}',
        child: Container(
          height: height,
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 18,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Local asset image with fade animation
                Image.asset(
                  wallpaper.imagePath,
                  fit: BoxFit.cover,
                  cacheWidth: 600,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.darkSurface,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.white38,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                // Favorite button
                Positioned(
                  top: 14,
                  right: 14,
                  child: Obx(
                    () => GestureDetector(
                      onTap: () =>
                          favoritesController.toggleFavorite(wallpaper.id),
                      child: AnimatedContainer(
                        duration: 300.ms,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: favoritesController.isFavorite(wallpaper.id)
                              ? AppColors.neonPink.withOpacity(0.85)
                              : Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          favoritesController.isFavorite(wallpaper.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                // Title overlay
                if (showTitle)
                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wallpaper.title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          wallpaper.category,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white70,
                                  ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .scale(begin: const Offset(0.98, 0.98)),
      ),
    );
  }
}
