import 'log_record.dart';

abstract class LogFormatter {
  const LogFormatter();

  String format(LogRecord record);
}

