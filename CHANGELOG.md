# Changelog

All notable changes to the `cross_platform_video_thumbnails` package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2025-11-04

### Added
- Initial package structure and implementation
- Cross-platform support for Android, iOS, Web, Windows, macOS, and Linux
- WASM compatibility with no dart:io imports in main interface
- Platform-specific implementations using conditional imports
- Support for JPEG, PNG, and WebP output formats
- Customizable thumbnail dimensions and quality
- Batch thumbnail generation
- Comprehensive error handling with ThumbnailException
- Platform detection and availability checking
- Example Flutter application
- Comprehensive test suite
- **Real thumbnail generation for Web platform**: Implemented actual thumbnail generation using HTML5 Canvas API with `drawImage()` and `toDataURL()` for JPEG, PNG, and WebP formats
- **Real thumbnail generation for Desktop platform**: Implemented FFmpeg-based thumbnail generation for Windows, macOS, and Linux with automatic FFmpeg detection
- **iOS native implementation**: Added complete iOS method channel implementation using AVFoundation for thumbnail generation
- **Platform detection improvements**: Enhanced platform detection to properly distinguish between desktop and mobile platforms at runtime
- **FFmpeg auto-detection**: Desktop implementation automatically finds FFmpeg in PATH or common installation locations (Windows, macOS, Linux)
- **Quality control for Web**: Web implementation now properly applies quality settings for JPEG and WebP formats
- **Aspect ratio handling**: Both web and desktop implementations now properly maintain aspect ratio with letterboxing support

### Platform Implementations
- **Web**: HTML5 video element + canvas API for WASM compatibility
- **Mobile**: Platform channels for native Android/iOS implementation
- **Desktop**: FFmpeg bindings and native video processing libraries

### Technical Features
- Conditional imports for platform-specific code
- Universal I/O operations using universal_io package
- Platform interface abstraction for consistent API
- Stub implementations for unsupported platforms
- Comprehensive model classes with copyWith support
- Type-safe enums for format selection

### Changed
- **Web implementation**: Replaced placeholder image generation with real canvas-based thumbnail extraction from video frames
- **Desktop implementation**: Replaced placeholder implementation with real FFmpeg-based thumbnail generation
- **Platform detection**: Improved runtime platform detection to correctly identify desktop vs mobile platforms
- **Error handling**: Enhanced error messages with FFmpeg-specific error details for desktop platform

### Fixed
- **iOS method channel**: Fixed `MissingPluginException` by implementing all required method channel handlers in iOS AppDelegate
- **Swift compilation errors**: Fixed Swift keyword conflict by renaming `extension` variable to `fileExtension` in iOS code
- **Web quality control**: Fixed quality parameter handling in web implementation using proper JS interop
- **Desktop quality mapping**: Fixed quality parameter mapping for different image formats (JPEG, PNG, WebP) in FFmpeg commands

## [0.0.2] - 2024-08-11

### Changed
- Updated dependencies to latest compatible versions
- Improved code formatting and linting compliance
- Enhanced documentation and examples
- Fixed platform detection and conditional imports

### Fixed
- Resolved formatting issues in web implementation
- Updated homepage URL for better package discoverability
- Improved error handling and exception messages

## [0.0.1] - 2024-01-01

### Added
- Initial release of cross_platform_video_thumbnails package
- Basic thumbnail generation functionality
- Platform detection and initialization
- Error handling and exception classes
- Example application and documentation
