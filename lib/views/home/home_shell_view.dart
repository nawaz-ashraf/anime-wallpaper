import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../widgets/glass_bottom_nav.dart';
import '../categories/categories_view.dart';
import '../favorites/favorites_view.dart';
import '../search/search_view.dart';
import '../settings/settings_view.dart';
import 'home_view.dart';

class HomeShellView extends StatelessWidget {
  const HomeShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      extendBody: true,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomeView(),
            CategoriesView(),
            FavoritesView(),
            SearchView(),
            SettingsView(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => GlassBottomNav(
          currentIndex: controller.currentIndex.value,
          onTap: controller.setIndex,
        ),
      ),
    );
  }
}
