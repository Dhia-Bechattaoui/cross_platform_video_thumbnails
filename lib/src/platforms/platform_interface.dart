import '../models/thumbnail_options.dart';
import '../models/thumbnail_result.dart';

/// Abstract interface for platform-specific thumbnail generation implementations
abstract class PlatformInterface {
  /// Generate a single thumbnail from a video file
  Future<ThumbnailResult> generateThumbnail(
    String videoPath,
    ThumbnailOptions options,
  );

  /// Generate multiple thumbnails from a video file
  Future<List<ThumbnailResult>> generateThumbnails(
    String videoPath,
    List<ThumbnailOptions> optionsList,
  );

  /// Check if the platform supports the given video format
  Future<bool> isVideoFormatSupported(String videoPath);

  /// Get the list of supported video formats for this platform
  List<String> getSupportedVideoFormats();

  /// Get the list of supported output formats for this platform
  List<ThumbnailFormat> getSupportedOutputFormats();

  /// Check if the platform is available and ready to use
  Future<bool> isPlatformAvailable();
}
