import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import '../platform_interface.dart';
import '../../models/thumbnail_options.dart';
import '../../models/thumbnail_result.dart';
import '../../exceptions/thumbnail_exception.dart';

/// Web platform implementation using HTML5 video and canvas API
class WebImplementation implements PlatformInterface {
  @override
  Future<ThumbnailResult> generateThumbnail(
    String videoPath,
    ThumbnailOptions options,
  ) async {
    try {
      final video = web.HTMLVideoElement()
        ..src = videoPath
        ..preload = 'metadata';

      // Wait for video metadata to load
      await video.onLoadedMetadata.first;

      // Set the video to the specified time position
      video.currentTime = options.timePosition;

      // Wait for the video to seek to the specified time
      await video.onSeeked.first;

      // Create canvas for thumbnail generation
      final canvas = web.HTMLCanvasElement();
      final ctx = canvas.getContext('2d') as web.CanvasRenderingContext2D;

      // Set canvas dimensions
      canvas.width = options.width;
      canvas.height = options.height;

      // Calculate dimensions maintaining aspect ratio if requested
      int drawWidth = options.width;
      int drawHeight = options.height;
      int drawX = 0;
      int drawY = 0;

      if (options.maintainAspectRatio) {
        final videoAspect = video.videoWidth / video.videoHeight;
        final canvasAspect = options.width / options.height;

        if (videoAspect > canvasAspect) {
          // Video is wider than canvas - fit to width
          drawHeight = (options.width / videoAspect).round();
          drawY = (options.height - drawHeight) ~/ 2;
        } else {
          // Video is taller than canvas - fit to height
          drawWidth = (options.height * videoAspect).round();
          drawX = (options.width - drawWidth) ~/ 2;
        }
      }

      // Fill background with black (in case of letterboxing)
      ctx.fillStyle = '#000000'.toJS;
      ctx.fillRect(0, 0, options.width, options.height);

      // Draw the video frame to canvas
      ctx.drawImage(video, drawX, drawY, drawWidth, drawHeight);

      // Convert canvas to image data using toDataURL
      // This is simpler and works reliably across browsers
      final mimeType = options.format.toMimeType();
      final quality = options.quality.clamp(0.0, 1.0);

      // toDataURL returns a base64-encoded data URL
      // For JPEG/WebP, quality is supported; for PNG, quality is ignored
      final dataUrl = canvas.toDataURL(mimeType, quality.toJS);

      // Extract base64 data from data URL (format: "data:image/jpeg;base64,/9j/4AAQ...")
      final base64Data = dataUrl.split(',').last;

      // Decode base64 to bytes
      final data = base64Decode(base64Data);

      // Calculate actual output dimensions
      final actualWidth = options.maintainAspectRatio
          ? drawWidth
          : options.width;
      final actualHeight = options.maintainAspectRatio
          ? drawHeight
          : options.height;

      return ThumbnailResult(
        data: data,
        width: actualWidth,
        height: actualHeight,
        format: options.format,
        timePosition: options.timePosition,
        size: data.length,
      );
    } catch (e) {
      throw ThumbnailException(
        'Failed to generate thumbnail on web platform',
        e,
      );
    }
  }

  @override
  Future<List<ThumbnailResult>> generateThumbnails(
    String videoPath,
    List<ThumbnailOptions> optionsList,
  ) async {
    final results = <ThumbnailResult>[];

    for (final options in optionsList) {
      final result = await generateThumbnail(videoPath, options);
      results.add(result);
    }

    return results;
  }

  @override
  Future<bool> isVideoFormatSupported(String videoPath) async {
    final video = web.HTMLVideoElement();
    final supportedFormats = getSupportedVideoFormats();

    // Check if the file extension is supported
    final extension = videoPath.split('.').last.toLowerCase();
    if (supportedFormats.contains(extension)) {
      return true;
    }

    // Additional check using canPlayType
    final canPlay = video.canPlayType('video/$extension');
    return canPlay.isNotEmpty && canPlay != 'probably';
  }

  @override
  List<String> getSupportedVideoFormats() {
    return ['mp4', 'webm', 'ogg', 'mov', 'avi', 'mkv'];
  }

  @override
  List<ThumbnailFormat> getSupportedOutputFormats() {
    return [ThumbnailFormat.jpeg, ThumbnailFormat.png, ThumbnailFormat.webp];
  }

  @override
  Future<bool> isPlatformAvailable() async {
    // Web platform is always available in web environment
    return true;
  }
}

/// Extension to convert ThumbnailFormat to MIME type
extension ThumbnailFormatExtension on ThumbnailFormat {
  String toMimeType() {
    switch (this) {
      case ThumbnailFormat.jpeg:
        return 'image/jpeg';
      case ThumbnailFormat.png:
        return 'image/png';
      case ThumbnailFormat.webp:
        return 'image/webp';
    }
  }
}

/// Factory function to create web implementation instance
PlatformInterface createPlatformImplementation() {
  return WebImplementation();
}
