import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/wallpaper_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/category_data.dart';
import '../../routes/app_routes.dart';
import '../../themes/app_theme_extension.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/premium_search_bar.dart';
import '../../widgets/section_header.dart';
import '../../widgets/shimmer_tile.dart';
import '../../widgets/trending_carousel.dart';
import '../../widgets/wallpaper_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallpaperController = Get.find<WallpaperController>();
    final homeController = Get.find<HomeController>();

    return SafeArea(
      child: Obx(
        () => CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.appName,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Find your next cinematic wallpaper',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: context.appThemeColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 20),
                    PremiumSearchBar(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => homeController.setIndex(3),
                      onClear: () => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),

            // ── Trending Section ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  title: 'Trending Now',
                  actionLabel: 'Refresh',
                  onAction: () => wallpaperController.refreshTrending(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: wallpaperController.isLoading.value
                    ? SizedBox(
                        height: 270,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => const SizedBox(
                            width: 220,
                            child: ShimmerTile(height: 260),
                          ),
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 16),
                          itemCount: 3,
                        ),
                      )
                    : TrendingCarousel(
                        wallpapers: wallpaperController.trending.toList(),
                        onSelect: (wallpaper) => Get.toNamed(
                            AppRoutes.details,
                            arguments: wallpaper),
                      ),
              ),
            ),

            // ── Categories Section ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: SectionHeader(title: 'Categories'),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 54,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: CategoryData.categories.length,
                  itemBuilder: (context, index) {
                    final category = CategoryData.categories[index];
                    return CategoryChip(
                      category: category,
                      isSelected:
                          wallpaperController.selectedCategory.value ==
                              category.name,
                      thumbnailPath: wallpaperController
                          .getCategoryThumbnail(category.name),
                      onTap: () =>
                          wallpaperController.setCategory(category.name),
                    );
                  },
                ),
              ),
            ),

            // ── Masonry Grid ──
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              sliver: SliverMasonryGrid.count(
                crossAxisCount:
                    MediaQuery.of(context).size.width > 700 ? 3 : 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childCount: wallpaperController.isLoading.value
                    ? 6
                    : wallpaperController.categoryWallpapers.length,
                itemBuilder: (context, index) {
                  if (wallpaperController.isLoading.value) {
                    return ShimmerTile(height: index.isEven ? 260 : 300);
                  }
                  final wallpaper =
                      wallpaperController.categoryWallpapers[index];
                  return WallpaperCard(
                    wallpaper: wallpaper,
                    onTap: () => Get.toNamed(AppRoutes.details,
                        arguments: wallpaper),
                    height: index.isEven ? 260 : 300,
                  );
                },
              ),
            ),

            // Bottom padding for nav bar
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
