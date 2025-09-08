import 'ansi_log_formatter.dart';
import 'ansi_theme.dart';
import 'core_logger.dart';
import 'log_formatter.dart';

class LoggerConfig {
  final LogLevel minLevel;
  final bool enableColors;
  final bool enableReleaseLogging;
  final LogFormatter formatter;

  LoggerConfig({
    this.minLevel = LogLevel.debug,
    this.enableColors = true,
    this.enableReleaseLogging = false,
    LogFormatter? formatter,
  }) : formatter =
            formatter ?? AnsiLogFormatter.theme(const AnsiThemeData.fancy());

  factory LoggerConfig.dev() => LoggerConfig(
        minLevel: LogLevel.debug,
        enableReleaseLogging: true,
        formatter: AnsiLogFormatter.theme(const AnsiThemeData.fancy()),
      );

  factory LoggerConfig.prod() => LoggerConfig(
        minLevel: LogLevel.info,
        enableReleaseLogging: true,
        formatter: AnsiLogFormatter.theme(const AnsiThemeData.minimal()),
      );

  factory LoggerConfig.quiet() => LoggerConfig(
        minLevel: LogLevel.error,
        enableReleaseLogging: false,
        formatter: AnsiLogFormatter.theme(const AnsiThemeData.ci()),
      );

  LoggerConfig copyWith({
    LogLevel? minLevel,
    bool? enableColors,
    bool? enableReleaseLogging,
    LogFormatter? formatter,
  }) {
    return LoggerConfig(
      minLevel: minLevel ?? this.minLevel,
      enableColors: enableColors ?? this.enableColors,
      enableReleaseLogging: enableReleaseLogging ?? this.enableReleaseLogging,
      formatter: formatter ?? this.formatter,
    );
  }
}
