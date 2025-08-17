// A cross-platform Flutter package for generating video thumbnails.
//
// This package supports Android, iOS, Web, Windows, macOS, and Linux with WASM compatibility.
// It provides a unified API for generating video thumbnails across all supported platforms.
//
// ## Features
//
// - **Cross-Platform Support**: Works on all 6 major platforms
// - **WASM Compatible**: No `dart:io` imports in the main interface
// - **Multiple Output Formats**: JPEG, PNG, and WebP support
// - **Customizable Dimensions**: Set width, height, and maintain aspect ratio
// - **Batch Processing**: Generate multiple thumbnails at once
// - **Quality Control**: Adjustable output quality
// - **Error Handling**: Comprehensive exception handling
//
// ## Usage
//
// ```dart
// import 'package:cross_platform_video_thumbnails/cross_platform_video_thumbnails.dart';
//
// void main() async {
//   // Initialize the package
//   await CrossPlatformVideoThumbnails.initialize();
//
//   // Generate a single thumbnail
//   final thumbnail = await CrossPlatformVideoThumbnails.generateThumbnail(
//     'path/to/video.mp4',
//     ThumbnailOptions(
//       timePosition: 5.0,
//       width: 320,
//       height: 240,
//       quality: 0.8,
//       format: ThumbnailFormat.jpeg,
//     ),
//   );
// }
// ```

// Library exports for cross_platform_video_thumbnails

export 'src/cross_platform_video_thumbnails_base.dart';
export 'src/models/thumbnail_options.dart';
export 'src/models/thumbnail_result.dart';
export 'src/exceptions/thumbnail_exception.dart';
