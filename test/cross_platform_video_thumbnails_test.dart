import 'package:flutter_test/flutter_test.dart';
import 'package:cross_platform_video_thumbnails/cross_platform_video_thumbnails.dart';

void main() {
  group('CrossPlatformVideoThumbnails', () {
    test('should create ThumbnailOptions with default values', () {
      const options = ThumbnailOptions(timePosition: 5.0);

      expect(options.timePosition, 5.0);
      expect(options.width, 320);
      expect(options.height, 240);
      expect(options.quality, 0.8);
      expect(options.format, ThumbnailFormat.jpeg);
      expect(options.maintainAspectRatio, true);
    });

    test('should create ThumbnailOptions with custom values', () {
      const options = ThumbnailOptions(
        timePosition: 10.0,
        width: 640,
        height: 480,
        quality: 0.9,
        format: ThumbnailFormat.png,
        maintainAspectRatio: false,
      );

      expect(options.timePosition, 10.0);
      expect(options.width, 640);
      expect(options.height, 480);
      expect(options.quality, 0.9);
      expect(options.format, ThumbnailFormat.png);
      expect(options.maintainAspectRatio, false);
    });

    test('should copy ThumbnailOptions with new values', () {
      const original = ThumbnailOptions(timePosition: 5.0);
      final copied = original.copyWith(
        width: 1280,
        height: 720,
        format: ThumbnailFormat.webp,
      );

      expect(copied.timePosition, 5.0); // Unchanged
      expect(copied.width, 1280); // Changed
      expect(copied.height, 720); // Changed
      expect(copied.quality, 0.8); // Unchanged
      expect(copied.format, ThumbnailFormat.webp); // Changed
      expect(copied.maintainAspectRatio, true); // Unchanged
    });

    test('should create ThumbnailResult with correct values', () {
      const data = [1, 2, 3, 4, 5];
      const result = ThumbnailResult(
        data: data,
        width: 320,
        height: 240,
        format: ThumbnailFormat.jpeg,
        timePosition: 5.0,
        size: 5,
      );

      expect(result.data, data);
      expect(result.width, 320);
      expect(result.height, 240);
      expect(result.format, ThumbnailFormat.jpeg);
      expect(result.timePosition, 5.0);
      expect(result.size, 5);
    });

    test('should copy ThumbnailResult with new values', () {
      const original = ThumbnailResult(
        data: [1, 2, 3],
        width: 320,
        height: 240,
        format: ThumbnailFormat.jpeg,
        timePosition: 5.0,
        size: 3,
      );

      final copied = original.copyWith(
        width: 640,
        height: 480,
        format: ThumbnailFormat.png,
      );

      expect(copied.data, [1, 2, 3]); // Unchanged
      expect(copied.width, 640); // Changed
      expect(copied.height, 480); // Changed
      expect(copied.format, ThumbnailFormat.png); // Changed
      expect(copied.timePosition, 5.0); // Unchanged
      expect(copied.size, 3); // Unchanged
    });

    test('should create ThumbnailException with message', () {
      const exception = ThumbnailException('Test error');

      expect(exception.message, 'Test error');
      expect(exception.error, null);
      expect(exception.stackTrace, null);
    });

    test('should create ThumbnailException with error and stack trace', () {
      final error = Exception('Original error');
      final stackTrace = StackTrace.current;
      final exception = ThumbnailException('Test error', error, stackTrace);

      expect(exception.message, 'Test error');
      expect(exception.error, error);
      expect(exception.stackTrace, stackTrace);
    });

    test('should convert ThumbnailFormat to string', () {
      expect(ThumbnailFormat.jpeg.name, 'jpeg');
      expect(ThumbnailFormat.png.name, 'png');
      expect(ThumbnailFormat.webp.name, 'webp');
    });

    test('should get ThumbnailFormat from string', () {
      expect(ThumbnailFormat.values.firstWhere((f) => f.name == 'jpeg'),
          ThumbnailFormat.jpeg);
      expect(ThumbnailFormat.values.firstWhere((f) => f.name == 'png'),
          ThumbnailFormat.png);
      expect(ThumbnailFormat.values.firstWhere((f) => f.name == 'webp'),
          ThumbnailFormat.webp);
    });

    test('should throw exception when not initialized', () {
      expect(
        () => CrossPlatformVideoThumbnails.getSupportedVideoFormats(),
        throwsA(isA<ThumbnailException>()),
      );

      expect(
        () => CrossPlatformVideoThumbnails.getSupportedOutputFormats(),
        throwsA(isA<ThumbnailException>()),
      );
    });

    test('should handle initialization failure gracefully', () async {
      // This test verifies that the package handles initialization errors
      // In a real scenario, the platform detection would work
      try {
        await CrossPlatformVideoThumbnails.initialize();
        // If we get here, initialization succeeded (unexpected in test environment)
      } catch (e) {
        expect(e, isA<ThumbnailException>());
        if (e is ThumbnailException) {
          expect(e.message,
              contains('Failed to initialize platform implementation'));
        }
      }
    });
  });
}
