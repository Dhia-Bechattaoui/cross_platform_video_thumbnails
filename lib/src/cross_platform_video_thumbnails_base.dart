import 'dart:async';
import 'platforms/platform_interface.dart';
import 'platforms/platform_detection.dart';
import 'models/thumbnail_options.dart';
import 'models/thumbnail_result.dart';
import 'exceptions/thumbnail_exception.dart';

/// Main class for cross-platform video thumbnail generation.
///
/// This class provides a unified API for generating video thumbnails across
/// all supported platforms (Android, iOS, Web, Windows, macOS, Linux).
///
/// The class uses static methods and automatically detects and initializes
/// the appropriate platform-specific implementation.
///
/// ## Usage
///
/// ```dart
/// // Initialize the package
/// await CrossPlatformVideoThumbnails.initialize();
///
/// // Generate a thumbnail
/// final thumbnail = await CrossPlatformVideoThumbnails.generateThumbnail(
///   videoPath,
///   ThumbnailOptions(timePosition: 5.0),
/// );
/// ```
class CrossPlatformVideoThumbnails {
  static PlatformInterface? _platform;
  static bool _initialized = false;

  /// Initialize the platform-specific implementation
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Platform detection and initialization will be handled by conditional imports
      _platform = await _getPlatformImplementation();
      _initialized = true;
    } catch (e) {
      throw ThumbnailException(
        'Failed to initialize platform implementation',
        e,
      );
    }
  }

  /// Generate a single thumbnail from a video file
  static Future<ThumbnailResult> generateThumbnail(
    String videoPath,
    ThumbnailOptions options,
  ) async {
    await _ensureInitialized();
    return _platform!.generateThumbnail(videoPath, options);
  }

  /// Generate multiple thumbnails from a video file
  static Future<List<ThumbnailResult>> generateThumbnails(
    String videoPath,
    List<ThumbnailOptions> optionsList,
  ) async {
    await _ensureInitialized();
    return _platform!.generateThumbnails(videoPath, optionsList);
  }

  /// Check if the platform supports the given video format
  static Future<bool> isVideoFormatSupported(String videoPath) async {
    await _ensureInitialized();
    return _platform!.isVideoFormatSupported(videoPath);
  }

  /// Get the list of supported video formats for the current platform
  static List<String> getSupportedVideoFormats() {
    if (!_initialized) {
      throw const ThumbnailException(
          'Platform not initialized. Call initialize() first.');
    }
    return _platform!.getSupportedVideoFormats();
  }

  /// Get the list of supported output formats for the current platform
  static List<ThumbnailFormat> getSupportedOutputFormats() {
    if (!_initialized) {
      throw const ThumbnailException(
          'Platform not initialized. Call initialize() first.');
    }
    return _platform!.getSupportedOutputFormats();
  }

  /// Check if the current platform is available and ready to use
  static Future<bool> isPlatformAvailable() async {
    await _ensureInitialized();
    return _platform!.isPlatformAvailable();
  }

  /// Ensure the platform is initialized before use
  static Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }

  /// Get the platform-specific implementation based on the current platform
  static Future<PlatformInterface> _getPlatformImplementation() async {
    try {
      // Use the platform detection module to get the appropriate implementation
      return getPlatformImplementation();
    } catch (e) {
      throw ThumbnailException(
        'Failed to get platform implementation: $e',
        e,
      );
    }
  }
}
