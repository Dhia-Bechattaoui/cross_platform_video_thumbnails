import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cross_platform_video_thumbnails/cross_platform_video_thumbnails.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cross Platform Video Thumbnails Example',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
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
  String? _selectedVideoPath;

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

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedVideoPath = result.files.single.path!;
        _status = 'Video selected: ${result.files.single.name}';
      });
    }
  }

  Future<void> _generateThumbnail() async {
    if (!_isInitialized) return;
    if (_selectedVideoPath == null) {
      setState(() {
        _status = 'Please select a video file first';
      });
      return;
    }

    try {
      setState(() {
        _isGenerating = true;
        _status = 'Generating thumbnail...';
      });

      final thumbnail = await CrossPlatformVideoThumbnails.generateThumbnail(
        _selectedVideoPath!,
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
    if (_selectedVideoPath == null) {
      setState(() {
        _status = 'Please select a video file first';
      });
      return;
    }

    try {
      setState(() {
        _isGenerating = true;
        _status = 'Generating multiple thumbnails...';
      });

      final thumbnails = await CrossPlatformVideoThumbnails.generateThumbnails(
        _selectedVideoPath!,
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
            ElevatedButton.icon(
              onPressed: _isInitialized ? _pickVideo : null,
              icon: const Icon(Icons.video_library),
              label: const Text('Select Video File'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            if (_selectedVideoPath != null) ...[
              const SizedBox(height: 8),
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Video: ${_selectedVideoPath!.split('/').last}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _isInitialized &&
                            !_isGenerating &&
                            _selectedVideoPath != null
                        ? _generateThumbnail
                        : null,
                    child: const Text('Generate Single'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _isInitialized &&
                            !_isGenerating &&
                            _selectedVideoPath != null
                        ? _generateMultipleThumbnails
                        : null,
                    child: const Text('Generate Multiple'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _thumbnails.isNotEmpty ? _clearThumbnails : null,
                    child: const Text('Clear'),
                  ),
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
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _getFormatIcon(thumbnail.format),
                                  color: _getFormatColor(thumbnail.format),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Thumbnail ${index + 1}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Display the thumbnail image
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.memory(
                                  Uint8List.fromList(thumbnail.data),
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 200,
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 48,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Display metadata
                            Text(
                              'Size: ${thumbnail.width}x${thumbnail.height}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              'Format: ${thumbnail.format.name.toUpperCase()} | '
                              'Size: ${_formatBytes(thumbnail.size)} | '
                              'Time: ${thumbnail.timePosition.toStringAsFixed(1)}s',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
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

  String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}
