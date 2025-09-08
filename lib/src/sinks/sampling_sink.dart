import 'dart:math';

import '../core_logger.dart';
import '../log_record.dart';

class SamplingSink extends LogSink {
  final LogSink _output;
  final Map<LogLevel, double> _rates;
  final Random _random;

  SamplingSink(
    this._output, {
    Map<LogLevel, double> rates = const {},
    Random? random,
  })  : _rates = rates,
        _random = random ?? Random();

  @override
  void call(LogRecord record) {
    final rate = _rates[record.level] ?? 1.0;
    if (_random.nextDouble() < rate) {
      _output(record);
    }
  }
}
