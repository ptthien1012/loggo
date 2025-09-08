import 'package:flutter_test/flutter_test.dart';
import 'package:loggo/loggo.dart';

import 'test_helpers.dart';

void main() {
  group('Sinks Test', () {
    test('SamplingSink', () {
      final testSink = TestSink();
      final samplingSink = SamplingSink(testSink, rates: {LogLevel.info: 0.5});

      for (int i = 0; i < 100; i++) {
        samplingSink(LogRecord(level: LogLevel.info, message: 'Test', name: 'Test', time: DateTime.now()));
      }

      expect(testSink.records.length, lessThan(80)); // Should be around 50
      expect(testSink.records.length, greaterThan(20));
    });

    test('RateLimitSink', () {
      final testSink = TestSink();
      final rateLimitSink = RateLimitSink(testSink, const Duration(seconds: 1), 5);

      for (int i = 0; i < 10; i++) {
        rateLimitSink(LogRecord(level: LogLevel.info, message: 'Test', name: 'Test', time: DateTime.now()));
      }

      expect(testSink.records.length, 5);
    });
  });
}

