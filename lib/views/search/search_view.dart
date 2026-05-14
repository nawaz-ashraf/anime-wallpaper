import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../controllers/search_controller.dart';
import '../../controllers/wallpaper_controller.dart';
import '../../routes/app_routes.dart';
import '../../themes/app_theme_extension.dart';
import '../../widgets/premium_search_bar.dart';
import '../../widgets/section_header.dart';
import '../../widgets/wallpaper_card.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit(String value) {
    final searchController = Get.find<WallpaperSearchController>();
    searchController.submitSearch(value);
  }

  @override
  Widget build(BuildContext context) {
    final wc = Get.find<WallpaperController>();
    final sc = Get.find<WallpaperSearchController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Search',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            PremiumSearchBar(
              controller: _controller,
              onChanged: (v) {
                wc.search(v);
                setState(() {});
              },
              onSubmitted: _handleSubmit,
              onClear: () {
                wc.clearSearch();
                setState(() {});
              },
            ),
            const SizedBox(height: 18),
            Obx(() => sc.recentSearches.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                          title: 'Recent searches',
                          actionLabel: 'Clear',
                          onAction: sc.clearRecents),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: sc.recentSearches
                            .map((q) => ActionChip(
                                  label: Text(q),
                                  onPressed: () {
                                    _controller.text = q;
                                    wc.search(q);
                                    setState(() {});
                                  },
                                  backgroundColor:
                                      context.appThemeColors.chipBackground,
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                          color:
                                              context.appThemeColors.chipText),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 18),
                    ],
                  )),
            Expanded(
              child: Obx(() {
                final results = wc.searchResults;
                if (results.isEmpty && _controller.text.isEmpty) {
                  return Center(
                      child: Text('Type to explore anime worlds',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: context
                                      .appThemeColors.textSecondary)));
                }
                if (results.isEmpty) {
                  return Center(
                      child: Text('No results found',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: context
                                      .appThemeColors.textSecondary)));
                }
                return MasonryGridView.count(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 700 ? 3 : 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final w = results[index];
                    return WallpaperCard(
                      wallpaper: w,
                      onTap: () =>
                          Get.toNamed(AppRoutes.details, arguments: w),
                      height: index.isEven ? 260 : 300,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
