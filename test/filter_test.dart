import 'package:flutter_test/flutter_test.dart';
import 'package:loggo/loggo.dart';

import 'test_helpers.dart';

void main() {
  group('Filter Test', () {
    test('minLevel=warning should only pass warning/error logs', () {
      final testSink = TestSink();
      loggo.addSink(testSink);
      loggo.configure(LoggerConfig(minLevel: LogLevel.warning));

      loggo.debug('This should be filtered');
      loggo.info('This should be filtered');
      loggo.success('This should be filtered');
      loggo.warning('This should pass');
      loggo.error('This should pass');

      expect(testSink.records.length, 2);
      expect(testSink.records[0].level, LogLevel.warning);
      expect(testSink.records[1].level, LogLevel.error);

      loggo.clearSinks();
    });
  });
}

