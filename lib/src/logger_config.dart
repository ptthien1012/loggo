import 'package:beauty_logger/beauty_logger.dart';
import 'package:beauty_logger/src/ansi_log_formatter.dart';
import 'package:beauty_logger/src/log_formatter.dart';

class LoggerConfig {
  LogLevel minLevel;
  bool enableColors;
  bool enableReleaseLogging;
  LogFormatter formatter;

  LoggerConfig({
    this.minLevel = LogLevel.debug,
    this.enableColors = true,
    this.enableReleaseLogging = false,
    LogFormatter? formatter,
  }) : formatter = formatter ?? AnsiLogFormatter();
}

