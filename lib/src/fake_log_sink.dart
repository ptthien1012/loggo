import 'package:beauty_logger/src/log_record.dart';

/// A fake log sink for testing.
///
/// This sink captures all log records it receives, allowing you to
/// inspect them in your unit tests.
class FakeLogSink {
  final List<LogRecord> records = [];

  void call(LogRecord record) {
    records.add(record);
  }

  void clear() {
    records.clear();
  }
}

