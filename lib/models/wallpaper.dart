class WallpaperModel {
  const WallpaperModel({
    required this.id,
    required this.title,
    required this.category,
    required this.imagePath,
    this.isTrending = false,
    this.resolution = '1080x1920',
  });

  final int id;
  final String title;
  final String category;
  final String imagePath;
  final bool isTrending;
  final String resolution;

  WallpaperModel copyWith({
    int? id,
    String? title,
    String? category,
    String? imagePath,
    bool? isTrending,
    String? resolution,
  }) {
    return WallpaperModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      isTrending: isTrending ?? this.isTrending,
      resolution: resolution ?? this.resolution,
    );
  }
}
