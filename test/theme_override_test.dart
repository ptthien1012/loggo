import 'package:flutter_test/flutter_test.dart';
import 'package:loggo/loggo.dart';

void main() {
  group('Theme Override Test', () {
    test('override icons should show new icon', () {
      final theme = const AnsiThemeData.fancy().copyWith(emoji: {LogLevel.info: '🚀'});
      final formatter = AnsiLogFormatter.theme(theme);
      final record = LogRecord(level: LogLevel.info, message: 'Test', name: 'Test', time: DateTime.now());

      final output = formatter.format(record);
      expect(output, contains('🚀'));
    });

    test('switch theme should not crash', () {
      loggo.configure(LoggerConfig(formatter: AnsiLogFormatter.theme(const AnsiThemeData.fancy())));
      loggo.info('Fancy log');

      loggo.configure(LoggerConfig(formatter: AnsiLogFormatter.theme(const AnsiThemeData.minimal())));
      loggo.info('Minimal log');

      loggo.configure(LoggerConfig(formatter: AnsiLogFormatter.theme(const AnsiThemeData.ci())));
      loggo.info('CI log');
    });
  });
}

