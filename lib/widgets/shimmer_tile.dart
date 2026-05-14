import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../themes/app_theme_extension.dart';

class ShimmerTile extends StatelessWidget {
  const ShimmerTile({
    super.key,
    this.height = 220,
    this.width = double.infinity,
    this.radius = 24,
  });

  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final themeColors = context.appThemeColors;
    return Shimmer.fromColors(
      baseColor: themeColors.shimmerBase,
      highlightColor: themeColors.shimmerHighlight,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: themeColors.cardOverlay,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
