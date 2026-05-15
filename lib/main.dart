import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'controllers/download_controller.dart';
import 'controllers/favorites_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/search_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/wallpaper_controller.dart';
import 'core/constants/app_constants.dart';
import 'repositories/wallpaper_repository.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'services/download_service.dart';
import 'services/local_storage_service.dart';
import 'themes/app_theme.dart';

import 'services/admob_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Initialize Ads
  await AdmobService.instance.initialize();

  final storageService = LocalStorageService();
  await storageService.init();

  Get.put<LocalStorageService>(storageService, permanent: true);
  Get.put(WallpaperRepository(), permanent: true);
  Get.put(ThemeController(storageService), permanent: true);
  Get.put(FavoritesController(storageService), permanent: true);
  Get.put(WallpaperController(Get.find()), permanent: true);
  Get.put(HomeController(), permanent: true);
  Get.put(WallpaperSearchController(storageService), permanent: true);
  Get.put(DownloadController(DownloadService()), permanent: true);

  await Get.find<ThemeController>().loadTheme();

  runApp(const AnimeVerseApp());
}

class AnimeVerseApp extends StatelessWidget {
  const AnimeVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ThemeController>(
      builder: (controller) {
        return GetMaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: controller.themeMode,
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
        );
      },
    );
  }
}
