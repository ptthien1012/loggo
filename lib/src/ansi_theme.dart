import 'core_logger.dart';

class AnsiColors {
  static const String reset = '\x1B[0m';
  static const String black = '\x1B[30m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String magenta = '\x1B[35m';
  static const String cyan = '\x1B[36m';
  static const String white = '\x1B[37m';
}

class AnsiThemeData {
  final Map<LogLevel, String> emoji;
  final Map<LogLevel, String> colors;
  final bool prettySpacing;
  final bool multilineJson;
  final String redactReplacement;

  const AnsiThemeData({
    required this.emoji,
    required this.colors,
    this.prettySpacing = true,
    this.multilineJson = true,
    this.redactReplacement = '🔒',
  });

  const AnsiThemeData.fancy()
      : emoji = const {
          LogLevel.debug: '🔍',
          LogLevel.info: 'ℹ️',
          LogLevel.success: '✅',
          LogLevel.warning: '⚠️',
          LogLevel.error: '❌',
        },
        colors = const {
          LogLevel.debug: AnsiColors.cyan,
          LogLevel.info: AnsiColors.blue,
          LogLevel.success: AnsiColors.green,
          LogLevel.warning: AnsiColors.yellow,
          LogLevel.error: AnsiColors.red,
        },
        prettySpacing = true,
        multilineJson = true,
        redactReplacement = '🔒';

  const AnsiThemeData.minimal()
      : emoji = const {
          LogLevel.debug: 'D',
          LogLevel.info: 'I',
          LogLevel.success: 'S',
          LogLevel.warning: 'W',
          LogLevel.error: 'E',
        },
        colors = const {
          LogLevel.debug: AnsiColors.cyan,
          LogLevel.info: AnsiColors.blue,
          LogLevel.success: AnsiColors.green,
          LogLevel.warning: AnsiColors.yellow,
          LogLevel.error: AnsiColors.red,
        },
        prettySpacing = false,
        multilineJson = false,
        redactReplacement = '🔒';

  const AnsiThemeData.ci()
      : emoji = const {},
        colors = const {},
        prettySpacing = false,
        multilineJson = false,
        redactReplacement = '***';

  AnsiThemeData copyWith({
    Map<LogLevel, String>? emoji,
    Map<LogLevel, String>? colors,
    bool? prettySpacing,
    bool? multilineJson,
    String? redactReplacement,
  }) {
    return AnsiThemeData(
      emoji: emoji ?? this.emoji,
      colors: colors ?? this.colors,
      prettySpacing: prettySpacing ?? this.prettySpacing,
      multilineJson: multilineJson ?? this.multilineJson,
      redactReplacement: redactReplacement ?? this.redactReplacement,
    );
  }
}
