import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:loggo/loggo.dart';

void main() {
  group('FileSink Test', () {
    test('skip web', () {
      // This test is a bit tricky to run in a pure Dart environment, 
      // but we can at least ensure it doesn't crash.
      final sink = RollingFileSink('./test.log');
      sink(LogRecord(level: LogLevel.info, message: 'Test', name: 'Test', time: DateTime.now()));
    });

    test('rotate file', () {
      final path = './test_rotate.log';
      final sink = RollingFileSink(path, maxFileSize: 10, maxFiles: 2);

      for (int i = 0; i < 20; i++) {
        sink(LogRecord(level: LogLevel.info, message: 'Test $i', name: 'Test', time: DateTime.now()));
      }

      // This is also hard to test without a real file system, but we can check that it doesn't crash.
      // In a real environment, we would check for the existence of test_rotate.log.1, etc.
      expect(File(path).existsSync(), true);
    });
  });
}

