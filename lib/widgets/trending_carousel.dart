import 'package:flutter/material.dart';

import '../models/wallpaper.dart';
import 'wallpaper_card.dart';

class TrendingCarousel extends StatefulWidget {
  const TrendingCarousel({
    super.key,
    required this.wallpapers,
    required this.onSelect,
  });

  final List<WallpaperModel> wallpapers;
  final ValueChanged<WallpaperModel> onSelect;

  @override
  State<TrendingCarousel> createState() => _TrendingCarouselState();
}

class _TrendingCarouselState extends State<TrendingCarousel> {
  late final PageController _controller;

  @override
  void initState() {
    _controller = PageController(viewportFraction: 0.8);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.wallpapers.isEmpty) {
      return const SizedBox(height: 240);
    }

    return SizedBox(
      height: 270,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.wallpapers.length,
        itemBuilder: (context, index) {
          final wallpaper = widget.wallpapers[index];
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double value = 1.0;
              if (_controller.position.hasContentDimensions) {
                final page =
                    _controller.page ?? _controller.initialPage.toDouble();
                value = page - index;
                value = (1 - (value.abs() * 0.12)).clamp(0.9, 1.0);
              }
              return Transform.scale(scale: value, child: child);
            },
            child: WallpaperCard(
              wallpaper: wallpaper,
              onTap: () => widget.onSelect(wallpaper),
              height: 260,
            ),
          );
        },
      ),
    );
  }
}
