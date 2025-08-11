# Changelog

All notable changes to the `cross_platform_video_thumbnails` package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

## [Unreleased]

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
