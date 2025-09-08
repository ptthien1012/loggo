import 'dart:async';
import 'dart:developer' as developer;

import 'log_record.dart';
import 'logger_config.dart';
import 'tagged_logger.dart';

abstract class LogSink {
  void call(LogRecord record);
}

enum LogLevel {
  debug('DEBUG', 700),
  info('INFO', 800),
  success('SUCCESS', 800),
  warning('WARNING', 900),
  error('ERROR', 1000),
  handRaise('HAND_RAISE', 700),
  meeting('MEETING', 700),
  network('NETWORK', 700);

  const LogLevel(this.name, this.value);
  final String name;
  final int value;
}

class Loggo {
  Loggo._() : _config = LoggerConfig();

  static final Loggo instance = Loggo._();

  LoggerConfig _config;
  final _sinks = <LogSink>[];
  final _streamController = StreamController<LogRecord>.broadcast();

  Stream<LogRecord> get stream => _streamController.stream;

  void configure(LoggerConfig config) {
    _config = config;
  }

  void dev() => configure(LoggerConfig.dev());
  void prod() => configure(LoggerConfig.prod());
  void quiet() => configure(LoggerConfig.quiet());

  void addSink(LogSink sink) {
    _sinks.add(sink);
  }

  void removeSink(LogSink sink) {
    _sinks.remove(sink);
  }

  void clearSinks() {
    _sinks.clear();
  }

  TaggedLogger tagged(String name) => TaggedLogger(name);

  void log(
    LogLevel level,
    String message, {
    String? name,
    Object? data,
    Map<String, dynamic>? context,
    StackTrace? stackTrace,
  }) {
    _log(level, message,
        name: name, data: data, context: context, stackTrace: stackTrace);
  }

  void debug(String message,
          {String? name, Object? data, Map<String, dynamic>? context}) =>
      _log(LogLevel.debug, message, name: name, data: data, context: context);

  void info(String message,
          {String? name, Object? data, Map<String, dynamic>? context}) =>
      _log(LogLevel.info, message, name: name, data: data, context: context);

  void success(String message,
          {String? name, Object? data, Map<String, dynamic>? context}) =>
      _log(LogLevel.success, message, name: name, data: data, context: context);

  void warning(String message,
          {String? name, Object? data, Map<String, dynamic>? context}) =>
      _log(LogLevel.warning, message, name: name, data: data, context: context);

  void error(
    String message, {
    String? name,
    Object? data,
    Map<String, dynamic>? context,
    StackTrace? stackTrace,
  }) =>
      _log(LogLevel.error, message,
          name: name, data: data, context: context, stackTrace: stackTrace);

  void data(Object data, {String? name, Map<String, dynamic>? context}) =>
      _log(LogLevel.info, '', name: name, data: data, context: context);

  void debugData(Object data, {String? name, Map<String, dynamic>? context}) =>
      _log(LogLevel.debug, '', name: name, data: data, context: context);

  void infoData(Object data, {String? name, Map<String, dynamic>? context}) =>
      _log(LogLevel.info, '', name: name, data: data, context: context);

  final _onceMessages = <String>{};
  void logOnce(LogLevel level, String message,
      {String? name,
      Object? data,
      Map<String, dynamic>? context,
      StackTrace? stackTrace}) {
    if (_onceMessages.add('$level-$name-$message')) {
      _log(level, message,
          name: name, data: data, context: context, stackTrace: stackTrace);
    }
  }

  final _throttleTimestamps = <String, DateTime>{};
  void throttle(LogLevel level, String message, Duration duration,
      {String? name,
      Object? data,
      Map<String, dynamic>? context,
      StackTrace? stackTrace}) {
    final key = '$level-$name-$message';
    final now = DateTime.now();
    if (_throttleTimestamps.containsKey(key) &&
        now.difference(_throttleTimestamps[key]!) < duration) {
      return;
    }
    _throttleTimestamps[key] = now;
    _log(level, message,
        name: name, data: data, context: context, stackTrace: stackTrace);
  }

  String? _lastLogMessage;
  void dedupe(LogLevel level, String message,
      {String? name,
      Object? data,
      Map<String, dynamic>? context,
      StackTrace? stackTrace}) {
    final currentLogMessage = '$level-$name-$message';
    if (currentLogMessage == _lastLogMessage) return;
    _lastLogMessage = currentLogMessage;
    _log(level, message,
        name: name, data: data, context: context, stackTrace: stackTrace);
  }

  void successData(Object data,
          {String? name, Map<String, dynamic>? context}) =>
      _log(LogLevel.success, '', name: name, data: data, context: context);

  void warningData(Object data,
          {String? name, Map<String, dynamic>? context}) =>
      _log(LogLevel.warning, '', name: name, data: data, context: context);

  void errorData(Object data,
          {String? name,
          Map<String, dynamic>? context,
          StackTrace? stackTrace}) =>
      _log(LogLevel.error, '',
          name: name, data: data, context: context, stackTrace: stackTrace);

  Future<T> measure<T>(String name, Future<T> Function() block) async {
    final stopwatch = Stopwatch()..start();
    final T result = await block();
    stopwatch.stop();
    info('Measure: $name took ${stopwatch.elapsedMilliseconds}ms',
        name: 'Measure');
    return result;
  }

  bool _isDebugMode() {
    try {
      // Try to use Flutter's kDebugMode if available
      return false; // Default to false for release mode
    } catch (e) {
      // If Flutter is not available, assume debug mode
      return true;
    }
  }

  void _log(
    LogLevel level,
    String message, {
    String? name,
    Object? data,
    Map<String, dynamic>? context,
    StackTrace? stackTrace,
  }) {
    if (level.value < _config.minLevel.value) return;
    if (!_config.enableReleaseLogging && _isDebugMode()) return;

    final record = LogRecord(
      level: level,
      message: message,
      name: name ?? 'Loggo',
      time: DateTime.now(),
      data: data,
      context: context,
      stackTrace: stackTrace,
    );

    final formattedMessage = _config.formatter.format(record);

    developer.log(
      formattedMessage,
      name: record.name,
      level: level.index * 200 + 800, // Scale to developer.log levels
      time: record.time,
      stackTrace: record.stackTrace,
    );

    _streamController.add(record);

    for (final sink in _sinks) {
      try {
        sink(record);
      } catch (e, s) {
        developer.log('Error in log sink: $e', name: 'Loggo', stackTrace: s);
      }
    }
  }
}
