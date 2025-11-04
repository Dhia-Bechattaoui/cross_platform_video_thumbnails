import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import '../platform_interface.dart';
import '../../models/thumbnail_options.dart';
import '../../models/thumbnail_result.dart';
import '../../exceptions/thumbnail_exception.dart';

/// Desktop platform implementation using FFmpeg
class DesktopImplementation implements PlatformInterface {
  static String? _ffmpegPath;

  /// Find FFmpeg executable path
  static Future<String?> _findFFmpeg() async {
    if (_ffmpegPath != null) return _ffmpegPath;

    // Common FFmpeg executable names
    final executableNames = ['ffmpeg', 'ffmpeg.exe'];

    // Check common installation paths
    final commonPaths = <String>[];

    if (io.Platform.isWindows) {
      commonPaths.addAll([
        r'C:\ffmpeg\bin\ffmpeg.exe',
        r'C:\Program Files\ffmpeg\bin\ffmpeg.exe',
        r'C:\Program Files (x86)\ffmpeg\bin\ffmpeg.exe',
      ]);
    } else if (io.Platform.isMacOS) {
      commonPaths.addAll([
        '/usr/local/bin/ffmpeg',
        '/opt/homebrew/bin/ffmpeg',
        '/usr/bin/ffmpeg',
      ]);
    } else if (io.Platform.isLinux) {
      commonPaths.addAll([
        '/usr/bin/ffmpeg',
        '/usr/local/bin/ffmpeg',
        '/snap/bin/ffmpeg',
      ]);
    }

    // First check PATH
    for (final name in executableNames) {
      try {
        final result = await io.Process.run(name, ['-version']);
        if (result.exitCode == 0) {
          _ffmpegPath = name;
          return _ffmpegPath;
        }
      } catch (e) {
        // Continue searching
      }
    }

    // Then check common paths
    for (final path in commonPaths) {
      final file = io.File(path);
      if (await file.exists()) {
        _ffmpegPath = path;
        return _ffmpegPath;
      }
    }

    return null;
  }

  @override
  Future<ThumbnailResult> generateThumbnail(
    String videoPath,
    ThumbnailOptions options,
  ) async {
    try {
      // Check if file exists
      final file = io.File(videoPath);
      if (!await file.exists()) {
        throw ThumbnailException('Video file not found: $videoPath');
      }

      // Find FFmpeg
      final ffmpegPath = await _findFFmpeg();
      if (ffmpegPath == null) {
        throw const ThumbnailException(
          'FFmpeg not found. Please install FFmpeg and ensure it is in your PATH.',
        );
      }

      // Create temporary output file
      final tempDir = io.Directory.systemTemp;
      final extension = _getExtensionForFormat(options.format);
      final outputPath =
          '${tempDir.path}/thumbnail_${DateTime.now().millisecondsSinceEpoch}.$extension';

      // Build FFmpeg command
      final args = <String>[
        '-i', videoPath, // Input video
        '-ss', options.timePosition.toString(), // Seek to time position
        '-vframes', '1', // Extract only one frame
        '-vf', _buildVideoFilter(options), // Video filter for scaling/cropping
      ];

      // Add format-specific quality parameters
      if (options.format == ThumbnailFormat.webp) {
        args.addAll(['-quality', _getQualityParameter(options)]);
      } else {
        args.addAll(['-q:v', _getQualityParameter(options)]);
      }

      args.addAll([
        '-f', _getFormatForFFmpeg(options.format), // Output format
        '-y', // Overwrite output file
        outputPath, // Output file
      ]);

      // Run FFmpeg
      final process = await io.Process.start(ffmpegPath, args);

      // Capture stderr for error messages
      final stderrBuffer = StringBuffer();
      process.stderr
          .transform(const Utf8Decoder())
          .listen((data) => stderrBuffer.write(data));

      final exitCode = await process.exitCode;

      if (exitCode != 0) {
        throw ThumbnailException(
          'FFmpeg failed with exit code $exitCode: ${stderrBuffer.toString()}',
        );
      }

      // Read the generated thumbnail
      final outputFile = io.File(outputPath);
      if (!await outputFile.exists()) {
        throw const ThumbnailException('FFmpeg did not generate output file');
      }

      final thumbnailData = await outputFile.readAsBytes();

      // Clean up temporary file
      try {
        await outputFile.delete();
      } catch (e) {
        // Ignore cleanup errors
      }

      // Get actual image dimensions (simplified - in production, parse image metadata)
      final actualWidth = options.width;
      final actualHeight = options.height;

      return ThumbnailResult(
        data: thumbnailData,
        width: actualWidth,
        height: actualHeight,
        format: options.format,
        timePosition: options.timePosition,
        size: thumbnailData.length,
      );
    } catch (e) {
      if (e is ThumbnailException) rethrow;
      throw ThumbnailException(
        'Failed to generate thumbnail on desktop platform: $e',
        e,
      );
    }
  }

  /// Build video filter string for FFmpeg
  String _buildVideoFilter(ThumbnailOptions options) {
    if (options.maintainAspectRatio) {
      // Scale maintaining aspect ratio, then pad if needed
      return 'scale=${options.width}:${options.height}:force_original_aspect_ratio=decrease,pad=${options.width}:${options.height}:(ow-iw)/2:(oh-ih)/2:black';
    } else {
      // Scale without maintaining aspect ratio
      return 'scale=${options.width}:${options.height}';
    }
  }

  /// Get quality parameter for FFmpeg
  String _getQualityParameter(ThumbnailOptions options) {
    // FFmpeg quality: 2-31 for JPEG (lower is better), 0-51 for PNG (lower is better)
    // For WebP: -quality 0-100 (higher is better)
    switch (options.format) {
      case ThumbnailFormat.jpeg:
        // JPEG: 2 (best) to 31 (worst), map 0.0-1.0 to 2-31
        final quality = 2 + (31 - 2) * (1.0 - options.quality);
        return quality.round().toString();
      case ThumbnailFormat.png:
        // PNG: 0 (best) to 9 (worst), but we'll use -q:v with 0-51 scale
        final quality = 0 + (51 - 0) * (1.0 - options.quality);
        return quality.round().toString();
      case ThumbnailFormat.webp:
        // WebP: use -quality flag separately (0-100, higher is better)
        final quality = (options.quality * 100).round();
        return quality.toString();
    }
  }

  /// Get format string for FFmpeg
  String _getFormatForFFmpeg(ThumbnailFormat format) {
    switch (format) {
      case ThumbnailFormat.jpeg:
        return 'image2';
      case ThumbnailFormat.png:
        return 'image2';
      case ThumbnailFormat.webp:
        return 'webp';
    }
  }

  /// Get file extension for format
  String _getExtensionForFormat(ThumbnailFormat format) {
    switch (format) {
      case ThumbnailFormat.jpeg:
        return 'jpg';
      case ThumbnailFormat.png:
        return 'png';
      case ThumbnailFormat.webp:
        return 'webp';
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
    try {
      final file = io.File(videoPath);
      if (!await file.exists()) {
        return false;
      }

      final extension = videoPath.split('.').last.toLowerCase();
      final supportedFormats = getSupportedVideoFormats();

      return supportedFormats.contains(extension);
    } catch (e) {
      return false;
    }
  }

  @override
  List<String> getSupportedVideoFormats() {
    return [
      'mp4',
      'mov',
      'avi',
      'mkv',
      'webm',
      'flv',
      'wmv',
      'm4v',
      '3gp',
      'ogv',
      'ts',
      'mts',
      'm2ts',
    ];
  }

  @override
  List<ThumbnailFormat> getSupportedOutputFormats() {
    return [ThumbnailFormat.jpeg, ThumbnailFormat.png, ThumbnailFormat.webp];
  }

  @override
  Future<bool> isPlatformAvailable() async {
    // Desktop platform is available if we can access dart:io and FFmpeg is installed
    try {
      // Test if we can create a temporary file
      final tempFile = io.File('${io.Directory.systemTemp.path}/test.tmp');
      await tempFile.create();
      await tempFile.delete();

      // Check if FFmpeg is available
      final ffmpegPath = await _findFFmpeg();
      return ffmpegPath != null;
    } catch (e) {
      return false;
    }
  }
}

/// Factory function to create desktop implementation instance
PlatformInterface createDesktopPlatformImplementation() {
  return DesktopImplementation();
}
