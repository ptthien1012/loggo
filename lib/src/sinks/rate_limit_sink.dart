import '../core_logger.dart';
import '../log_record.dart';

class RateLimitSink extends LogSink {
  final LogSink _output;
  final Duration _window;
  final int _maxLogs;
  final Map<String, List<DateTime>> _logTimestamps = {};

  RateLimitSink(this._output, this._window, this._maxLogs);

  @override
  void call(LogRecord record) {
    final key = record.level.toString();
    final now = DateTime.now();

    _logTimestamps.putIfAbsent(key, () => []);
    _logTimestamps[key]!.removeWhere((t) => now.difference(t) > _window);

    if (_logTimestamps[key]!.length < _maxLogs) {
      _logTimestamps[key]!.add(now);
      _output(record);
    }
  }
}
