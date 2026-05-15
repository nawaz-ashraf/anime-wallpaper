import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

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

    Timer(const Duration(milliseconds: 3500), _handleNavigation);
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
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // ── Cinematic Background Particles ──
          ...List.generate(15, (index) {
            final random = math.Random(index);
            return _FloatingParticle(
              color: index.isEven ? AppColors.neonBlue : AppColors.primary,
              random: random,
            );
          }),

          // ── Background Glow ──
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonBlue.withOpacity(0.15),
                    blurRadius: 150,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          // ── Main Content ──
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with Neon Aura and Glow
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Aura
                    Animate(
                      onPlay: (controller) => controller.repeat(),
                      effects: [
                        CustomEffect(
                          duration: const Duration(seconds: 2),
                          builder: (context, value, child) {
                            return Container(
                              width: 180 + (20 * math.sin(value * 2 * math.pi)),
                              height: 180 + (20 * math.sin(value * 2 * math.pi)),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.neonBlue.withOpacity(0.3),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.neonBlue.withOpacity(0.2),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    // The Logo
                    Animate(
                      effects: [
                        FadeEffect(
                            duration: const Duration(milliseconds: 1200),
                            curve: Curves.easeIn),
                        ScaleEffect(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1),
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.elasticOut,
                        ),
                      ],
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 40,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/logo/app_logo.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image,
                                    size: 100, color: Colors.white24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // App Name with Cinematic Reveal
                Animate(
                  effects: [
                    FadeEffect(
                        delay: const Duration(milliseconds: 500),
                        duration: const Duration(milliseconds: 800)),
                    SlideEffect(
                      begin: const Offset(0, 0.5),
                      end: const Offset(0, 0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutCubic,
                    ),
                  ],
                  child: Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          shadows: [
                            Shadow(
                              color: AppColors.neonBlue.withOpacity(0.8),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                  ),
                ),

                const SizedBox(height: 12),

                // Tagline
                Animate(
                  effects: [
                    FadeEffect(
                        delay: const Duration(milliseconds: 1200),
                        duration: const Duration(milliseconds: 1000)),
                  ],
                  child: Text(
                    AppConstants.tagline.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white60,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w500,
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

class _FloatingParticle extends StatefulWidget {
  const _FloatingParticle({required this.color, required this.random});
  final Color color;
  final math.Random random;

  @override
  State<_FloatingParticle> createState() => _FloatingParticleState();
}

class _FloatingParticleState extends State<_FloatingParticle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late double _top;
  late double _left;
  late double _size;

  @override
  void initState() {
    super.initState();
    _size = widget.random.nextDouble() * 4 + 2;
    _top = widget.random.nextDouble() * 800;
    _left = widget.random.nextDouble() * 400;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.random.nextInt(5) + 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: _top - (_controller.value * 100),
          left: _left,
          child: Opacity(
            opacity: 1 - _controller.value,
            child: Container(
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.5),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
