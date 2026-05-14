import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart' as spi;

import '../../core/constants/app_assets.dart';
import '../../routes/app_routes.dart';
import '../../services/local_storage_service.dart';
import '../../themes/app_colors.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late final PageController _controller;

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      title: 'Anime artistry in 4K',
      description:
          'Discover cinematic anime wallpapers curated for true otaku vibes.',
      animation: AppAssets.onboardingAnimation,
      gradient: [AppColors.primary, AppColors.neonBlue],
    ),
    _OnboardingData(
      title: 'Download & favorite instantly',
      description:
          'Save to your gallery with one tap and build your ultimate collection.',
      animation: AppAssets.onboardingAnimationAlt,
      gradient: [AppColors.neonPink, AppColors.accent],
    ),
    _OnboardingData(
      title: 'Personalized for your mood',
      description:
          'Search by category, vibe, or character. Your screen, your universe.',
      animation: AppAssets.onboardingAnimation,
      gradient: [AppColors.neonGreen, AppColors.secondary],
    ),
  ];

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    final storage = Get.find<LocalStorageService>();
    await storage.setOnboardingSeen(true);
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.darkBackground,
                      page.gradient.first.withOpacity(0.65),
                      page.gradient.last.withOpacity(0.45),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Animate(
                          effects: [
                            const FadeEffect(
                              duration: Duration(milliseconds: 600),
                            )
                          ],
                          child: Lottie.asset(
                            page.animation,
                            width: 220,
                            height: 220,
                            repeat: true,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Animate(
                          effects: [
                            SlideEffect(
                              begin: const Offset(0, 0.2),
                              end: const Offset(0, 0),
                              duration: const Duration(milliseconds: 500),
                            )
                          ],
                          child: Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Animate(
                          effects: [
                            const FadeEffect(
                              duration: Duration(milliseconds: 800),
                            )
                          ],
                          child: Text(
                            page.description,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 48,
            child: Column(
              children: [
                spi.SmoothPageIndicator(
                  controller: _controller,
                  count: _pages.length,
                  effect: spi.WormEffect(
                    dotColor: Colors.white.withOpacity(0.3),
                    activeDotColor: Colors.white,
                    dotHeight: 8,
                    dotWidth: 18,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _finishOnboarding,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(
                      'Get Started',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  const _OnboardingData({
    required this.title,
    required this.description,
    required this.animation,
    required this.gradient,
  });

  final String title;
  final String description;
  final String animation;
  final List<Color> gradient;
}
