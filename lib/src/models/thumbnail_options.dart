/// Configuration options for thumbnail generation
class ThumbnailOptions {
  /// The time position in seconds where the thumbnail should be generated
  final double timePosition;

  /// The width of the thumbnail in pixels
  final int width;

  /// The height of the thumbnail in pixels
  final int height;

  /// The quality of the thumbnail (0.0 to 1.0)
  final double quality;

  /// The output format for the thumbnail
  final ThumbnailFormat format;

  /// Whether to maintain aspect ratio
  final bool maintainAspectRatio;

  const ThumbnailOptions({
    required this.timePosition,
    this.width = 320,
    this.height = 240,
    this.quality = 0.8,
    this.format = ThumbnailFormat.jpeg,
    this.maintainAspectRatio = true,
  });

  /// Creates a copy of this object with the given fields replaced
  ThumbnailOptions copyWith({
    double? timePosition,
    int? width,
    int? height,
    double? quality,
    ThumbnailFormat? format,
    bool? maintainAspectRatio,
  }) {
    return ThumbnailOptions(
      timePosition: timePosition ?? this.timePosition,
      width: width ?? this.width,
      height: height ?? this.height,
      quality: quality ?? this.quality,
      format: format ?? this.format,
      maintainAspectRatio: maintainAspectRatio ?? this.maintainAspectRatio,
    );
  }
}

/// Supported thumbnail output formats
enum ThumbnailFormat {
  /// JPEG format
  jpeg,

  /// PNG format
  png,

  /// WebP format
  webp,
}
