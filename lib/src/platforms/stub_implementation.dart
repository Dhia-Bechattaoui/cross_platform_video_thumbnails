import 'platform_interface.dart';
import '../models/thumbnail_options.dart';
import '../models/thumbnail_result.dart';
import '../exceptions/thumbnail_exception.dart';

/// Stub implementation for when platform-specific code is not available
class StubImplementation implements PlatformInterface {
  @override
  Future<ThumbnailResult> generateThumbnail(
    String videoPath,
    ThumbnailOptions options,
  ) async {
    throw const ThumbnailException(
      'Platform implementation not available. This platform is not supported.',
    );
  }

  @override
  Future<List<ThumbnailResult>> generateThumbnails(
    String videoPath,
    List<ThumbnailOptions> optionsList,
  ) async {
    throw const ThumbnailException(
      'Platform implementation not available. This platform is not supported.',
    );
  }

  @override
  Future<bool> isVideoFormatSupported(String videoPath) async {
    return false;
  }

  @override
  List<String> getSupportedVideoFormats() {
    return <String>[];
  }

  @override
  List<ThumbnailFormat> getSupportedOutputFormats() {
    return <ThumbnailFormat>[];
  }

  @override
  Future<bool> isPlatformAvailable() async {
    return false;
  }
}
