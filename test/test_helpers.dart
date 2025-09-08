import 'package:loggo/loggo.dart';

class TestSink extends LogSink {
  final records = <LogRecord>[];

  @override
  void call(LogRecord record) {
    records.add(record);
  }

  void clear() {
    records.clear();
  }
}
