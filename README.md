# cross_platform_video_thumbnails

A cross-platform Flutter package for generating video thumbnails that supports Android, iOS, Web, Windows, macOS, and Linux with WASM compatibility.

## Features

- **Cross-Platform Support**: Works on all 6 major platforms
- **WASM Compatible**: No `dart:io` imports in the main interface
- **Multiple Output Formats**: JPEG, PNG, and WebP support
- **Customizable Dimensions**: Set width, height, and maintain aspect ratio
- **Batch Processing**: Generate multiple thumbnails at once
- **Quality Control**: Adjustable output quality
- **Error Handling**: Comprehensive exception handling

## Supported Platforms

| Platform | Implementation | Status |
|----------|----------------|---------|
| **Web** | HTML5 Video + Canvas API | ✅ Implemented |
| **Android** | Platform Channels + Native | ✅ Implemented |
| **iOS** | Platform Channels + Native | ✅ Implemented |
| **Windows** | FFmpeg Bindings | ✅ Implemented |
| **macOS** | FFmpeg Bindings | ✅ Implemented |
| **Linux** | FFmpeg Bindings | ✅ Implemented |

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  cross_platform_video_thumbnails: ^0.0.2

## Usage

### Basic Example

```dart
import 'package:cross_platform_video_thumbnails/cross_platform_video_thumbnails.dart';

void main() async {
  // Initialize the package
  await CrossPlatformVideoThumbnails.initialize();
  
  // Generate a single thumbnail
  final thumbnail = await CrossPlatformVideoThumbnails.generateThumbnail(
    'path/to/video.mp4',
    ThumbnailOptions(
      timePosition: 5.0, // 5 seconds into the video
      width: 320,
      height: 240,
      quality: 0.8,
      format: ThumbnailFormat.jpeg,
    ),
  );
  
  print('Generated thumbnail: ${thumbnail.size} bytes');
}
```

### Advanced Example

```dart
// Generate multiple thumbnails at different time positions
final thumbnails = await CrossPlatformVideoThumbnails.generateThumbnails(
  'path/to/video.mp4',
  [
    ThumbnailOptions(
      timePosition: 0.0, // Start of video
      width: 640,
      height: 480,
      format: ThumbnailFormat.png,
    ),
    ThumbnailOptions(
      timePosition: 30.0, // 30 seconds in
      width: 320,
      height: 240,
      format: ThumbnailFormat.jpeg,
      quality: 0.9,
    ),
    ThumbnailOptions(
      timePosition: 60.0, // 1 minute in
      width: 1280,
      height: 720,
      format: ThumbnailFormat.webp,
      maintainAspectRatio: false,
    ),
  ],
);

// Check platform capabilities
final supportedFormats = CrossPlatformVideoThideoThumbnails.getSupportedVideoFormats();
final supportedOutputs = CrossPlatformVideoThumbnails.getSupportedOutputFormats();

// Verify video format support
final isSupported = await CrossPlatformVideoThumbnails.isVideoFormatSupported('video.avi');
```

### Platform Detection

```dart
// Check if the current platform is available
final isAvailable = await CrossPlatformVideoThumbnails.isPlatformAvailable();

if (isAvailable) {
  // Platform is ready to use
  final thumbnail = await CrossPlatformVideoThumbnails.generateThumbnail(
    videoPath,
    options,
  );
} else {
  print('Platform not supported');
}
```

## API Reference

### ThumbnailOptions

```dart
class ThumbnailOptions {
  final double timePosition;        // Time in seconds
  final int width;                  // Output width in pixels
  final int height;                 // Output height in pixels
  final double quality;             // Quality (0.0 to 1.0)
  final ThumbnailFormat format;     // Output format
  final bool maintainAspectRatio;   // Preserve video aspect ratio
}
```

### ThumbnailResult

```dart
class ThumbnailResult {
  final List<int> data;             // Image data as bytes
  final int width;                  // Actual output width
  final int height;                 // Actual output height
  final ThumbnailFormat format;     // Output format
  final double timePosition;        // Time position used
  final int size;                   // File size in bytes
}
```

### Supported Formats

#### Input Video Formats
- **Web**: MP4, WebM, OGG, MOV, AVI, MKV
- **Mobile**: MP4, MOV, 3GP, AVI, MKV, WebM
- **Desktop**: MP4, MOV, AVI, MKV, WebM, FLV, WMV, M4V, 3GP, OGV, TS, MTS, M2TS

#### Output Image Formats
- JPEG (all platforms)
- PNG (all platforms)
- WebP (all platforms)

## Platform-Specific Notes

### Web Platform
- Uses HTML5 video element and canvas API
- Fully WASM compatible
- No additional dependencies required
- Limited by browser video codec support

### Mobile Platforms (Android/iOS)
- Uses platform channels for native implementation
- Requires platform-specific native code
- Better performance for large videos
- Full access to device video processing capabilities

### Desktop Platforms (Windows/macOS/Linux)
- Uses FFmpeg bindings or native libraries
- Best performance and format support
- Requires FFmpeg installation on target systems
- Full control over video processing parameters

## Error Handling

The package provides comprehensive error handling through `ThumbnailException`:

```dart
try {
  final thumbnail = await CrossPlatformVideoThumbnails.generateThumbnail(
    videoPath,
    options,
  );
} on ThumbnailException catch (e) {
  print('Thumbnail generation failed: ${e.message}');
  if (e.error != null) {
    print('Underlying error: ${e.error}');
  }
}
```

## Dependencies

- `flutter`: Flutter SDK
- `universal_io`: Cross-platform I/O operations
- `meta`: Metadata annotations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Implement your changes
4. Add tests
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Roadmap

- [ ] FFmpeg integration for desktop platforms
- [ ] GPU acceleration support
- [ ] Video metadata extraction
- [ ] Thumbnail caching
- [ ] Progress callbacks for long operations
- [ ] More output formats (GIF, TIFF)
- [ ] Video thumbnail grid generation
