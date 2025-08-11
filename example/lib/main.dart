import 'package:flutter/material.dart';
import 'package:cross_platform_video_thumbnails/cross_platform_video_thumbnails.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cross Platform Video Thumbnails Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ThumbnailGeneratorPage(),
    );
  }
}

class ThumbnailGeneratorPage extends StatefulWidget {
  const ThumbnailGeneratorPage({super.key});

  @override
  State<ThumbnailGeneratorPage> createState() => _ThumbnailGeneratorPageState();
}

class _ThumbnailGeneratorPageState extends State<ThumbnailGeneratorPage> {
  bool _isInitialized = false;
  bool _isGenerating = false;
  String _status = 'Not initialized';
  List<ThumbnailResult> _thumbnails = [];

  @override
  void initState() {
    super.initState();
    _initializePackage();
  }

  Future<void> _initializePackage() async {
    try {
      setState(() {
        _status = 'Initializing...';
      });

      await CrossPlatformVideoThumbnails.initialize();

      final isAvailable =
          await CrossPlatformVideoThumbnails.isPlatformAvailable();

      setState(() {
        _isInitialized = true;
        _status = isAvailable
            ? 'Ready - Platform available'
            : 'Ready - Platform not available';
      });
    } catch (e) {
      setState(() {
        _status = 'Initialization failed: $e';
      });
    }
  }

  Future<void> _generateThumbnail() async {
    if (!_isInitialized) return;

    try {
      setState(() {
        _isGenerating = true;
        _status = 'Generating thumbnail...';
      });

      // Generate a sample thumbnail (using a placeholder video path)
      final thumbnail = await CrossPlatformVideoThumbnails.generateThumbnail(
        'sample_video.mp4', // This would be a real video path in practice
        const ThumbnailOptions(
          timePosition: 5.0,
          width: 320,
          height: 240,
          quality: 0.8,
          format: ThumbnailFormat.jpeg,
        ),
      );

      setState(() {
        _thumbnails.add(thumbnail);
        _status = 'Generated thumbnail: ${thumbnail.size} bytes';
      });
    } catch (e) {
      setState(() {
        _status = 'Generation failed: $e';
      });
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  Future<void> _generateMultipleThumbnails() async {
    if (!_isInitialized) return;

    try {
      setState(() {
        _isGenerating = true;
        _status = 'Generating multiple thumbnails...';
      });

      final thumbnails = await CrossPlatformVideoThumbnails.generateThumbnails(
        'sample_video.mp4',
        [
          const ThumbnailOptions(
            timePosition: 0.0,
            width: 320,
            height: 240,
            format: ThumbnailFormat.jpeg,
          ),
          const ThumbnailOptions(
            timePosition: 10.0,
            width: 640,
            height: 480,
            format: ThumbnailFormat.png,
          ),
          const ThumbnailOptions(
            timePosition: 20.0,
            width: 1280,
            height: 720,
            format: ThumbnailFormat.webp,
          ),
        ],
      );

      setState(() {
        _thumbnails.addAll(thumbnails);
        _status = 'Generated ${thumbnails.length} thumbnails';
      });
    } catch (e) {
      setState(() {
        _status = 'Generation failed: $e';
      });
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  void _clearThumbnails() {
    setState(() {
      _thumbnails.clear();
      _status = 'Thumbnails cleared';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Thumbnail Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status: $_status',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Initialized: $_isInitialized',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (_isInitialized) ...[
                      const SizedBox(height: 8),
                      FutureBuilder<bool>(
                        future:
                            CrossPlatformVideoThumbnails.isPlatformAvailable(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              'Platform Available: ${snapshot.data}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            );
                          }
                          return const Text('Checking platform...');
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _isInitialized && !_isGenerating
                      ? _generateThumbnail
                      : null,
                  child: const Text('Generate Single'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isInitialized && !_isGenerating
                      ? _generateMultipleThumbnails
                      : null,
                  child: const Text('Generate Multiple'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _thumbnails.isNotEmpty ? _clearThumbnails : null,
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_thumbnails.isNotEmpty) ...[
              Text(
                'Generated Thumbnails (${_thumbnails.length}):',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _thumbnails.length,
                  itemBuilder: (context, index) {
                    final thumbnail = _thumbnails[index];
                    return Card(
                      child: ListTile(
                        title: Text('Thumbnail ${index + 1}'),
                        subtitle: Text(
                          '${thumbnail.width}x${thumbnail.height} '
                          '${thumbnail.format.name.toUpperCase()} '
                          '(${thumbnail.size} bytes) '
                          'at ${thumbnail.timePosition}s',
                        ),
                        trailing: Icon(
                          _getFormatIcon(thumbnail.format),
                          color: _getFormatColor(thumbnail.format),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getFormatIcon(ThumbnailFormat format) {
    switch (format) {
      case ThumbnailFormat.jpeg:
        return Icons.image;
      case ThumbnailFormat.png:
        return Icons.image_aspect_ratio;
      case ThumbnailFormat.webp:
        return Icons.image_not_supported;
    }
  }

  Color _getFormatColor(ThumbnailFormat format) {
    switch (format) {
      case ThumbnailFormat.jpeg:
        return Colors.blue;
      case ThumbnailFormat.png:
        return Colors.green;
      case ThumbnailFormat.webp:
        return Colors.orange;
    }
  }
}
