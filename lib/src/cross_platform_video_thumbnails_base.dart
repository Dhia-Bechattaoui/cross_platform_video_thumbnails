import 'dart:async';
import 'platforms/platform_interface.dart';
import 'models/thumbnail_options.dart';
import 'models/thumbnail_result.dart';
import 'exceptions/thumbnail_exception.dart';

/// Main class for cross-platform video thumbnail generation
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
    // Import the platform detection module
    // This will be resolved at compile time based on the target platform
    try {
      // For now, we'll use a simple approach
      // In a real implementation, you would use the conditional imports from platform_detection.dart

      // Check if we're on web
      if (identical(0, 0.0)) {
        // This is a simple way to detect web vs native
        // In practice, you'd use proper platform detection
        throw UnimplementedError('Web platform not yet implemented');
      }

      // Check if we're on mobile
      if (identical(0, 0.0)) {
        // Mobile platform detection
        throw UnimplementedError('Mobile platform not yet implemented');
      }

      // Default to desktop
      throw UnimplementedError('Desktop platform not yet implemented');
    } catch (e) {
      throw ThumbnailException(
        'Failed to get platform implementation: $e',
        e,
      );
    }
  }
}
