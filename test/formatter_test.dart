import 'package:flutter_test/flutter_test.dart';
import 'package:loggo/loggo.dart';

void main() {
  group('Formatter Test', () {
    final record = LogRecord(
      level: LogLevel.info,
      message: 'Test message',
      name: 'TestLogger',
      time: DateTime.now(),
      data: {
        'id': 123,
        'type': 'test',
        'status': 'ok',
        'message': 'some data',
        'code': 200,
        'password': 'supersecret',
        'token': 'supersecrettoken',
        'authorization': 'supersecretauth',
        'secret': 'supersecretsecret',
        'items': List.generate(20, (i) => i),
      },
      context: {'user': 'testuser'},
    );

    test('fancy formatter', () {
      final formatter = AnsiLogFormatter.theme(const AnsiThemeData.fancy());
      final output = formatter.format(record);

      expect(output, contains('INFO'));
      expect(output, contains('ℹ️'));
      expect(output, contains('\n')); // Line break
      expect(output, contains('🔒')); // Redacted
      expect(output, contains('... (12 more items)')); // List preview
    });

    test('minimal formatter', () {
      final formatter = AnsiLogFormatter.theme(const AnsiThemeData.minimal());
      final output = formatter.format(record);

      expect(output, isNot(contains('\n'))); // No line break
      expect(output, contains('ctx:'));
      expect(output, contains('data:'));
    });

    test('ci formatter', () {
      final formatter = AnsiLogFormatter.theme(const AnsiThemeData.ci());
      final output = formatter.format(record);

      expect(output, isNot(contains('ℹ️'))); // No emoji
      expect(output, isNot(contains('\x1B['))); // No ANSI codes
      expect(output, isNot(contains('\n'))); // Single-line JSON
    });
  });
}

