import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../views/category/category_detail_view.dart';
import '../views/details/wallpaper_detail_view.dart';
import '../views/home/home_shell_view.dart';
import '../views/onboarding/onboarding_view.dart';
import '../views/splash/splash_view.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashView()),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingView()),
    GetPage(name: AppRoutes.home, page: () => const HomeShellView()),
    GetPage(name: AppRoutes.details, page: () => const WallpaperDetailView()),
    GetPage(name: AppRoutes.category, page: () => const CategoryDetailView()),
  ];
}
