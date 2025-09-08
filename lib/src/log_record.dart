import 'core_logger.dart';

class LogRecord {
  final LogLevel level;
  final String message;
  final String name;
  final DateTime time;
  final Object? data;
  final Map<String, dynamic>? context;
  final StackTrace? stackTrace;

  LogRecord({
    required this.level,
    required this.message,
    required this.name,
    required this.time,
    this.data,
    this.context,
    this.stackTrace,
  });

  Map<String, dynamic> toJson() => {
        'level': level.toString().split('.').last,
        'message': message,
        'name': name,
        'time': time.toIso8601String(),
        'data': data,
        'context': context,
        'stackTrace': stackTrace?.toString(),
      };
}

