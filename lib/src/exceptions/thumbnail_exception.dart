/// Exception thrown when thumbnail generation fails
class ThumbnailException implements Exception {
  /// The error message
  final String message;

  /// The underlying error if any
  final Object? error;

  /// The stack trace if available
  final StackTrace? stackTrace;

  /// Creates a new [ThumbnailException] instance.
  ///
  /// [message] is required and should describe what went wrong.
  /// [error] is optional and can contain the underlying error object.
  /// [stackTrace] is optional and can contain the stack trace for debugging.
  const ThumbnailException(
    this.message, [
    this.error,
    this.stackTrace,
  ]);

  @override
  String toString() {
    if (error != null) {
      return 'ThumbnailException: $message\nError: $error';
    }
    return 'ThumbnailException: $message';
  }
}
