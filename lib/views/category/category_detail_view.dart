import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../controllers/wallpaper_controller.dart';
import '../../core/constants/category_data.dart';
import '../../routes/app_routes.dart';
import '../../themes/app_colors.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/wallpaper_card.dart';

class CategoryDetailView extends StatelessWidget {
  const CategoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final wc = Get.find<WallpaperController>();
    final categoryName = Get.arguments as String? ?? '';
    final meta = CategoryData.byName(categoryName);
    final wallpapers = wc.wallpapers
        .where((w) => w.category == categoryName)
        .toList();
    final thumbnail = wc.getCategoryThumbnail(categoryName);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              (meta?.gradient.first ?? AppColors.primary).withOpacity(0.45),
              AppColors.darkBackground,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
                title: Text(categoryName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: GlassContainer(
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: thumbnail != null
                                ? DecorationImage(
                                    image: AssetImage(thumbnail),
                                    fit: BoxFit.cover)
                                : null,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: thumbnail == null
                              ? Icon(meta?.icon ?? Icons.auto_awesome,
                                  color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(meta?.subtitle ?? 'Premium collection',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text('${wallpapers.length} wallpapers',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.white70)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 450.ms),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 700 ? 3 : 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childCount: wallpapers.length,
                  itemBuilder: (context, index) {
                    final w = wallpapers[index];
                    return WallpaperCard(
                      wallpaper: w,
                      onTap: () =>
                          Get.toNamed(AppRoutes.details, arguments: w),
                      height: index.isEven ? 260 : 300,
                    );
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
