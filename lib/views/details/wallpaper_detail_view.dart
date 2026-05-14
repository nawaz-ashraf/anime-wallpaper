import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../controllers/download_controller.dart';
import '../../controllers/favorites_controller.dart';
import '../../controllers/wallpaper_controller.dart';
import '../../models/wallpaper.dart';
import '../../themes/app_colors.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/wallpaper_card.dart';

class WallpaperDetailView extends StatefulWidget {
  const WallpaperDetailView({super.key});

  @override
  State<WallpaperDetailView> createState() => _WallpaperDetailViewState();
}

class _WallpaperDetailViewState extends State<WallpaperDetailView> {
  @override
  Widget build(BuildContext context) {
    final wallpaper = Get.arguments as WallpaperModel?;
    if (wallpaper == null) {
      return const Scaffold(
        body: Center(child: Text('Wallpaper not found')),
      );
    }

    final favoritesController = Get.find<FavoritesController>();
    final downloadController = Get.find<DownloadController>();
    final wallpaperController = Get.find<WallpaperController>();

    final similar = wallpaperController.getSimilar(wallpaper);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // Blurred background
          Positioned.fill(
            child: Image.asset(
              wallpaper.imagePath,
              fit: BoxFit.cover,
              cacheWidth: 400,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.darkBackground,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: Colors.black.withOpacity(0.35),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      const Spacer(),
                      Obx(
                        () => IconButton(
                          icon: Icon(
                            favoritesController.isFavorite(wallpaper.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                favoritesController.isFavorite(wallpaper.id)
                                    ? AppColors.neonPink
                                    : Colors.white,
                          ),
                          onPressed: () => favoritesController
                              .toggleFavorite(wallpaper.id),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share_rounded,
                            color: Colors.white),
                        onPressed: () => Share.share(
                            'Check out this amazing ${wallpaper.category} wallpaper on AnimeVerse 4K!'),
                      ),
                    ],
                  ),
                ),

                // Main wallpaper
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Hero(
                      tag: 'wallpaper_${wallpaper.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: InteractiveViewer(
                          minScale: 0.9,
                          maxScale: 2.6,
                          child: Image.asset(
                            wallpaper.imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.darkSurface,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.white38,
                                  size: 48,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 500.ms),
                ),
                const SizedBox(height: 16),

                // Info card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wallpaper.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${wallpaper.category} • ${wallpaper.resolution}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                        const SizedBox(height: 14),
                        Obx(
                          () => Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: downloadController
                                          .isDownloading.value
                                      ? null
                                      : () async {
                                          final success =
                                              await downloadController
                                                  .downloadWallpaper(
                                                      wallpaper);
                                          if (!context.mounted) return;
                                          Get.snackbar(
                                            success
                                                ? 'Download complete'
                                                : 'Download failed',
                                            success
                                                ? 'Saved to your gallery'
                                                : 'Please check permissions',
                                            backgroundColor: Colors.black87,
                                            colorText: Colors.white,
                                            snackPosition:
                                                SnackPosition.BOTTOM,
                                            margin: const EdgeInsets.all(16),
                                          );
                                        },
                                  icon:
                                      const Icon(Icons.download_rounded),
                                  label: Text(
                                      downloadController.isDownloading.value
                                          ? 'Saving...'
                                          : 'Download'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Obx(
                                () => GestureDetector(
                                  onTap: () => favoritesController
                                      .toggleFavorite(wallpaper.id),
                                  child: AnimatedContainer(
                                    duration: const Duration(
                                        milliseconds: 300),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: favoritesController
                                              .isFavorite(wallpaper.id)
                                          ? AppColors.neonPink
                                              .withOpacity(0.85)
                                          : Colors.white
                                              .withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      favoritesController
                                              .isFavorite(wallpaper.id)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(
                          () => downloadController.isDownloading.value
                              ? LinearProgressIndicator(
                                  value:
                                      downloadController.progress.value,
                                  minHeight: 4,
                                  backgroundColor: Colors.white24,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          AppColors.secondary),
                                )
                              : const SizedBox(height: 4),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Similar wallpapers
                if (similar.isNotEmpty)
                  SizedBox(
                    height: 190,
                    child: ListView.separated(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: similar.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final item = similar[index];
                        return SizedBox(
                          width: 140,
                          child: WallpaperCard(
                            wallpaper: item,
                            onTap: () => Get.off(
                              () => const WallpaperDetailView(),
                              arguments: item,
                            ),
                            height: 180,
                            showTitle: false,
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
