import 'dart:async';
import 'package:flutter/services.dart';
import '../platform_interface.dart';
import '../../models/thumbnail_options.dart';
import '../../models/thumbnail_result.dart';
import '../../exceptions/thumbnail_exception.dart';

/// Mobile platform implementation using platform channels
class MobileImplementation implements PlatformInterface {
  static const MethodChannel _channel =
      MethodChannel('cross_platform_video_thumbnails');

  @override
  Future<ThumbnailResult> generateThumbnail(
    String videoPath,
    ThumbnailOptions options,
  ) async {
    try {
      final Map<String, dynamic> arguments = {
        'videoPath': videoPath,
        'timePosition': options.timePosition,
        'width': options.width,
        'height': options.height,
        'quality': options.quality,
        'format': options.format.name,
        'maintainAspectRatio': options.maintainAspectRatio,
      };

      final Map<String, dynamic> result = await _channel.invokeMethod(
        'generateThumbnail',
        arguments,
      );

      if (result['error'] != null) {
        throw ThumbnailException(result['error']);
      }

      final Uint8List data = Uint8List.fromList(
        List<int>.from(result['data']),
      );

      return ThumbnailResult(
        data: data,
        width: result['width'],
        height: result['height'],
        format: ThumbnailFormat.values.firstWhere(
          (f) => f.name == result['format'],
        ),
        timePosition: result['timePosition'].toDouble(),
        size: data.length,
      );
    } catch (e) {
      throw ThumbnailException(
        'Failed to generate thumbnail on mobile platform',
        e,
      );
    }
  }

  @override
  Future<List<ThumbnailResult>> generateThumbnails(
    String videoPath,
    List<ThumbnailOptions> optionsList,
  ) async {
    try {
      final List<Map<String, dynamic>> argumentsList = optionsList
          .map((options) => {
                'videoPath': videoPath,
                'timePosition': options.timePosition,
                'width': options.width,
                'height': options.height,
                'quality': options.quality,
                'format': options.format.name,
                'maintainAspectRatio': options.maintainAspectRatio,
              })
          .toList();

      final List<dynamic> results = await _channel.invokeMethod(
        'generateThumbnails',
        {'optionsList': argumentsList},
      );

      final List<ThumbnailResult> thumbnails = <ThumbnailResult>[];

      for (final Map<String, dynamic> result in results) {
        if (result['error'] != null) {
          throw ThumbnailException(result['error']);
        }

        final Uint8List data = Uint8List.fromList(
          List<int>.from(result['data']),
        );

        thumbnails.add(ThumbnailResult(
          data: data,
          width: result['width'],
          height: result['height'],
          format: ThumbnailFormat.values.firstWhere(
            (f) => f.name == result['format'],
          ),
          timePosition: result['timePosition'].toDouble(),
          size: data.length,
        ));
      }

      return thumbnails;
    } catch (e) {
      throw ThumbnailException(
        'Failed to generate thumbnails on mobile platform',
        e,
      );
    }
  }

  @override
  Future<bool> isVideoFormatSupported(String videoPath) async {
    try {
      final bool result = await _channel.invokeMethod(
        'isVideoFormatSupported',
        {'videoPath': videoPath},
      );
      return result;
    } catch (e) {
      throw ThumbnailException(
        'Failed to check video format support on mobile platform',
        e,
      );
    }
  }

  @override
  List<String> getSupportedVideoFormats() {
    return ['mp4', 'mov', '3gp', 'avi', 'mkv', 'webm'];
  }

  @override
  List<ThumbnailFormat> getSupportedOutputFormats() {
    return [
      ThumbnailFormat.jpeg,
      ThumbnailFormat.png,
      ThumbnailFormat.webp,
    ];
  }

  @override
  Future<bool> isPlatformAvailable() async {
    try {
      final bool result = await _channel.invokeMethod('isPlatformAvailable');
      return result;
    } catch (e) {
      // If the method channel is not available, the platform is not supported
      return false;
    }
  }
}
