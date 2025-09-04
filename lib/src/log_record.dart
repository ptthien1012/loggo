import 'package:beauty_logger/beauty_logger.dart';

/// Represents a single log event.
class LogRecord {
  final LogLevel level;
  final String message;
  final String name;
  final DateTime time;
  final Object? data;
  final StackTrace? stackTrace;

  LogRecord({
    required this.level,
    required this.message,
    required this.name,
    required this.time,
    this.data,
    this.stackTrace,
  });
}

