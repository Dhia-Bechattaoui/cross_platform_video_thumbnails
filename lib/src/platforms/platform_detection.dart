import 'dart:io' as io;
import 'platform_interface.dart';

// Conditional imports for different platforms
// Web: dart.library.html available
// Mobile/Desktop: dart.library.io available
import 'web/web_implementation.dart'
    if (dart.library.io) 'mobile/mobile_implementation.dart'
    show createPlatformImplementation;

// Separate import for desktop (only when dart.library.io is available)
import 'desktop/desktop_implementation.dart'
    if (dart.library.io) 'desktop/desktop_implementation.dart'
    show createDesktopPlatformImplementation;

/// Factory function to get the appropriate platform implementation
PlatformInterface getPlatformImplementation() {
  try {
    // Check platform at runtime
    final platform = io.Platform.operatingSystem;

    // Desktop platforms
    if (platform == 'windows' || platform == 'macos' || platform == 'linux') {
      // Use desktop implementation
      return createDesktopPlatformImplementation();
    } else {
      // Mobile platforms (android/ios) or web fallback
      // Use mobile implementation (or web if io not available)
      return createPlatformImplementation();
    }
  } catch (e) {
    // If dart:io is not available, we're on web
    // Use web implementation
    return createPlatformImplementation();
  }
}
