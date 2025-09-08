import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

import 'src/core_logger.dart';
import 'src/logger_config.dart';
import 'src/log_record.dart';
import 'src/tagged_logger.dart';

/// Enhanced logger with colors, JSON formatting, and proper debug console support
class AppLogger {
  /// Global configuration for the logger.
  static LoggerConfig _config = LoggerConfig();

  /// Configures the global logger settings.
  ///
  /// [minLevel]: The minimum level of logs to display.
  /// [enableColors]: Whether to use ANSI colors in the output.
  /// [enableReleaseLogging]: Whether to allow logging in release builds.
  static void configure({
    LogLevel? minLevel,
    bool? enableColors,
    bool? enableReleaseLogging,
  }) {
    _config = LoggerConfig(
      minLevel: minLevel ?? _config.minLevel,
      enableColors: enableColors ?? _config.enableColors,
      enableReleaseLogging:
          enableReleaseLogging ?? _config.enableReleaseLogging,
    );
  }

  /// Creates a logger instance with a default name (tag).
  static TaggedLogger tagged(String name) {
    return TaggedLogger(name);
  }

  /// A list of sinks to forward log records to.
  static final List<Function(LogRecord record)> _sinks = [];

  /// Adds a sink to receive log records.
  ///
  /// Sinks are callbacks that can be used to forward logs to external services
  /// like a logging server, a file, or a crash reporting tool.
  static void addSink(Function(LogRecord record) sink) {
    _sinks.add(sink);
  }

  /// Removes a sink from the list.
  static void removeSink(Function(LogRecord record) sink) {
    _sinks.remove(sink);
  }

  /// Log info messages (green)
  static void info(String message, {String? name, Object? data}) {
    _log(LogLevel.info, message, name: name, data: data);
  }

  /// Log error messages (red)
  static void error(
    String message, {
    String? name,
    Object? data,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.error,
      message,
      name: name,
      data: data,
      stackTrace: stackTrace,
    );
  }

  /// Log success messages (green)
  static void success(String message, {String? name, Object? data}) {
    _log(LogLevel.success, message, name: name, data: data);
  }

  /// Log warning messages (yellow)
  static void warning(String message, {String? name, Object? data}) {
    _log(LogLevel.warning, message, name: name, data: data);
  }

  /// Log debug messages (cyan)
  static void debug(String message, {String? name, Object? data}) {
    _log(LogLevel.debug, message, name: name, data: data);
  }

  /// Log hand raise events (blue)
  static void handRaise(String message, {String? name, Object? data}) {
    _log(LogLevel.handRaise, message, name: name, data: data);
  }

  /// Log meeting events (magenta)
  static void meeting(String message, {String? name, Object? data}) {
    _log(LogLevel.meeting, message, name: name, data: data);
  }

  /// Log network events (white)
  static void network(String message, {String? name, Object? data}) {
    _log(LogLevel.network, message, name: name, data: data);
  }

  /// Internal logging method
  static void _log(
    LogLevel level,
    String message, {
    String? name,
    Object? data,
    StackTrace? stackTrace,
  }) {
    // Check if logging is enabled in release mode
    if (!kDebugMode && !_config.enableReleaseLogging) return;

    // Check if the log level is high enough
    if (level.value < _config.minLevel.value) return;

    final logName = name ?? 'APP';
    final time = DateTime.now();

    final record = LogRecord(
      level: level,
      message: message,
      name: logName,
      time: time,
      data: data,
      stackTrace: stackTrace,
    );

    // Format the message
    final formattedMessage = _config.formatter.format(record);

    // Use developer.log for better VSCode debug console support
    developer.log(
      formattedMessage,
      time: time,
      name: logName,
      level: level.value,
      error: level == LogLevel.error ? message : null,
      stackTrace: stackTrace,
    );

    // Forward to sinks
    for (final sink in _sinks) {
      try {
        sink(record);
      } catch (e) {
        // To prevent a faulty sink from crashing the app, we log the error.
        developer.log('Error in log sink: $e', name: 'AppLogger', level: 1000);
      }
    }
  }
}
