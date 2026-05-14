import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../routes/app_routes.dart';
import '../../services/local_storage_service.dart';
import '../../themes/app_colors.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    Timer(const Duration(milliseconds: 2400), _handleNavigation);
  }

  Future<void> _handleNavigation() async {
    final storage = Get.find<LocalStorageService>();
    if (storage.isOnboardingSeen) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final shift = _controller.value;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.darkBackground,
                  AppColors.primary.withOpacity(0.65),
                  AppColors.neonBlue.withOpacity(0.45),
                  AppColors.darkBackground,
                ],
                begin: Alignment(-1 + shift, -1),
                end: Alignment(1 - shift, 1),
              ),
            ),
            child: child,
          );
        },
        child: Stack(
          children: [
            Positioned(
              top: -120,
              right: -80,
              child: _GlowOrb(
                color: AppColors.neonPink.withOpacity(0.4),
                size: 220,
              ),
            ),
            Positioned(
              bottom: -140,
              left: -90,
              child: _GlowOrb(
                color: AppColors.neonBlue.withOpacity(0.4),
                size: 260,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Animate(
                    effects: const [
                      FadeEffect(duration: Duration(milliseconds: 600))
                    ],
                    child: Lottie.asset(
                      AppAssets.splashAnimation,
                      width: 180,
                      height: 180,
                      repeat: true,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Animate(
                    effects: const [
                      SlideEffect(
                        begin: Offset(0, 0.2),
                        end: Offset(0, 0),
                        duration: Duration(milliseconds: 500),
                      ),
                    ],
                    child: Text(
                      AppConstants.appName,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Animate(
                    effects: const [
                      FadeEffect(duration: Duration(milliseconds: 800))
                    ],
                    child: Text(
                      AppConstants.tagline,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 120,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }
}
