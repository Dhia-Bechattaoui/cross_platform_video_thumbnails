import 'thumbnail_options.dart';

/// Result of a thumbnail generation operation
class ThumbnailResult {
  /// The generated thumbnail data as bytes
  final List<int> data;

  /// The width of the generated thumbnail
  final int width;

  /// The height of the generated thumbnail
  final int height;

  /// The format of the generated thumbnail
  final ThumbnailFormat format;

  /// The time position where the thumbnail was generated
  final double timePosition;

  /// The file size in bytes
  final int size;

  const ThumbnailResult({
    required this.data,
    required this.width,
    required this.height,
    required this.format,
    required this.timePosition,
    required this.size,
  });

  /// Creates a copy of this object with the given fields replaced
  ThumbnailResult copyWith({
    List<int>? data,
    int? width,
    int? height,
    ThumbnailFormat? format,
    double? timePosition,
    int? size,
  }) {
    return ThumbnailResult(
      data: data ?? this.data,
      width: width ?? this.width,
      height: height ?? this.height,
      format: format ?? this.format,
      timePosition: timePosition ?? this.timePosition,
      size: size ?? this.size,
    );
  }

  @override
  String toString() {
    return 'ThumbnailResult(width: $width, height: $height, format: $format, timePosition: $timePosition, size: $size bytes)';
  }
}
