import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../controllers/wallpaper_controller.dart';
import '../../core/constants/category_data.dart';
import '../../routes/app_routes.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_theme_extension.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final wallpaperController = Get.find<WallpaperController>();

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Text(
                'Categories',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = CategoryData.categories[index];
                  final thumbnail =
                      wallpaperController.getCategoryThumbnail(category.name);
                  final count =
                      wallpaperController.getCategoryCount(category.name);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () {
                        wallpaperController.setCategory(category.name);
                        Get.toNamed(
                          AppRoutes.category,
                          arguments: category.name,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  category.gradient.first.withOpacity(0.35),
                              blurRadius: 20,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Stack(
                            children: [
                              // Background thumbnail
                              if (thumbnail != null)
                                Positioned.fill(
                                  child: Image.asset(
                                    thumbnail,
                                    fit: BoxFit.cover,
                                    cacheWidth: 600,
                                    errorBuilder: (_, __, ___) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: category.gradient,
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              // Gradient overlay
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        category.gradient.first
                                            .withOpacity(0.75),
                                        category.gradient.last
                                            .withOpacity(0.9),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                ),
                              ),

                              // Glassmorphism overlay
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 2, sigmaY: 2),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.white.withOpacity(0.05),
                                    border: Border.all(
                                      color: Colors.white
                                          .withOpacity(0.08),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Circular thumbnail
                                      Container(
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white
                                                .withOpacity(0.3),
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: category
                                                  .gradient.first
                                                  .withOpacity(0.5),
                                              blurRadius: 12,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                          image: thumbnail != null
                                              ? DecorationImage(
                                                  image: AssetImage(
                                                      thumbnail),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                          color: Colors.white
                                              .withOpacity(0.18),
                                        ),
                                        child: thumbnail == null
                                            ? Icon(category.icon,
                                                color: Colors.white,
                                                size: 24)
                                            : null,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              category.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                  ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              category.subtitle,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      color:
                                                          Colors.white70),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Wallpaper count badge
                                      Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withOpacity(0.18),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                            color: Colors.white
                                                .withOpacity(0.1),
                                          ),
                                        ),
                                        child: Text(
                                          '$count',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight:
                                                    FontWeight.w700,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate(delay: Duration(milliseconds: index * 60))
                        .fadeIn(duration: 400.ms)
                        .slideX(begin: 0.05, end: 0),
                  );
                },
                childCount: CategoryData.categories.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
