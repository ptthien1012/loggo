import 'package:beauty_logger/beauty_logger.dart';

/// A logger instance with a pre-defined name (tag).
class TaggedLogger {
  final String name;

  TaggedLogger(this.name);

  /// Log info messages (green)
  void info(String message, {Object? data}) {
    AppLogger.info(message, name: name, data: data);
  }

  /// Log error messages (red)
  void error(String message, {Object? data, StackTrace? stackTrace}) {
    AppLogger.error(message, name: name, data: data, stackTrace: stackTrace);
  }

  /// Log success messages (green)
  void success(String message, {Object? data}) {
    AppLogger.success(message, name: name, data: data);
  }

  /// Log warning messages (yellow)
  void warning(String message, {Object? data}) {
    AppLogger.warning(message, name: name, data: data);
  }

  /// Log debug messages (cyan)
  void debug(String message, {Object? data}) {
    AppLogger.debug(message, name: name, data: data);
  }

  /// Log hand raise events (blue)
  void handRaise(String message, {Object? data}) {
    AppLogger.handRaise(message, name: name, data: data);
  }

  /// Log meeting events (magenta)
  void meeting(String message, {Object? data}) {
    AppLogger.meeting(message, name: name, data: data);
  }

  /// Log network events (white)
  void network(String message, {Object? data}) {
    AppLogger.network(message, name: name, data: data);
  }

  /// Log JSON data with pretty formatting
  void json(String message, Object? jsonData) {
    AppLogger.debug(message, name: name, data: jsonData);
  }
}

