import 'core_logger.dart';

class TaggedLogger {
  final Loggo _loggo;
  final String name;

  TaggedLogger(this.name) : _loggo = Loggo.instance;

  void log(LogLevel level, String message,
          {Object? data,
          Map<String, dynamic>? context,
          StackTrace? stackTrace}) =>
      _loggo.log(level, message,
          name: name, data: data, context: context, stackTrace: stackTrace);

  void d(String message, {Object? data, Map<String, dynamic>? context}) =>
      _loggo.debug(message, name: name, data: data, context: context);

  void i(String message, {Object? data, Map<String, dynamic>? context}) =>
      _loggo.info(message, name: name, data: data, context: context);

  void s(String message, {Object? data, Map<String, dynamic>? context}) =>
      _loggo.success(message, name: name, data: data, context: context);

  void w(String message, {Object? data, Map<String, dynamic>? context}) =>
      _loggo.warning(message, name: name, data: data, context: context);

  void e(String message,
          {Object? data,
          Map<String, dynamic>? context,
          StackTrace? stackTrace}) =>
      _loggo.error(message,
          name: name, data: data, context: context, stackTrace: stackTrace);

  void data(Object data, {Map<String, dynamic>? context}) =>
      _loggo.data(data, name: name, context: context);

  void debugData(Object data, {Map<String, dynamic>? context}) =>
      _loggo.debugData(data, name: name, context: context);

  void infoData(Object data, {Map<String, dynamic>? context}) =>
      _loggo.infoData(data, name: name, context: context);

  void successData(Object data, {Map<String, dynamic>? context}) =>
      _loggo.successData(data, name: name, context: context);

  void warningData(Object data, {Map<String, dynamic>? context}) =>
      _loggo.warningData(data, name: name, context: context);

  void errorData(Object data,
          {Map<String, dynamic>? context, StackTrace? stackTrace}) =>
      _loggo.errorData(data,
          name: name, context: context, stackTrace: stackTrace);
}
