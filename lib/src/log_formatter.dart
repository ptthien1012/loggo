import 'package:beauty_logger/src/log_record.dart';

/// Abstract class for formatting log records.
///
/// Extend this class to create a custom log formatter.
abstract class LogFormatter {
  String format(LogRecord record);
}

