import 'package:flutter_test/flutter_test.dart';
import 'package:beauty_logger/beauty_logger.dart';

void main() {
  group('AppLogger', () {
    late FakeLogSink fakeSink;

    setUp(() {
      // Reset configuration before each test
      AppLogger.configure(
        minLevel: LogLevel.debug,
        enableReleaseLogging: true, // Enable logging for tests
      );
      fakeSink = FakeLogSink();
      AppLogger.addSink(fakeSink);
    });

    tearDown(() {
      AppLogger.removeSink(fakeSink);
    });

    test('logs a message with the correct level and content', () {
      AppLogger.info('Test message');

      expect(fakeSink.records.length, 1);
      final record = fakeSink.records.first;
      expect(record.level, LogLevel.info);
      expect(record.message, 'Test message');
      expect(record.name, 'APP');
    });

    test('respects minLevel configuration', () {
      AppLogger.configure(minLevel: LogLevel.warning);

      AppLogger.info('This should not be logged');
      AppLogger.debug('This should not be logged either');
      AppLogger.warning('This should be logged');

      expect(fakeSink.records.length, 1);
      expect(fakeSink.records.first.level, LogLevel.warning);
    });

    test('TaggedLogger uses the correct name', () {
      final authLogger = AppLogger.tagged('Auth');
      authLogger.error('Login failed');

      expect(fakeSink.records.length, 1);
      final record = fakeSink.records.first;
      expect(record.level, LogLevel.error);
      expect(record.message, 'Login failed');
      expect(record.name, 'Auth');
    });

    test('logs data payload correctly', () {
      final data = {'userId': 123, 'action': 'logout'};
      AppLogger.success('User action', data: data);

      expect(fakeSink.records.length, 1);
      final record = fakeSink.records.first;
      expect(record.data, data);
    });
  });
}
