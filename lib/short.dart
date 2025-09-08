import 'loggo.dart';

// Message-based aliases
void d(String message, {String? name, Object? data, Map<String, dynamic>? context}) =>
    loggo.debug(message, name: name, data: data, context: context);

void i(String message, {String? name, Object? data, Map<String, dynamic>? context}) =>
    loggo.info(message, name: name, data: data, context: context);

void s(String message, {String? name, Object? data, Map<String, dynamic>? context}) =>
    loggo.success(message, name: name, data: data, context: context);

void w(String message, {String? name, Object? data, Map<String, dynamic>? context}) =>
    loggo.warning(message, name: name, data: data, context: context);

void e(String message, {String? name, Object? data, Map<String, dynamic>? context, StackTrace? stackTrace}) =>
    loggo.error(message, name: name, data: data, context: context, stackTrace: stackTrace);

// Helper aliases
Future<T> m<T>(String name, Future<T> Function() block) => loggo.measure(name, block);

void once(LogLevel level, String message, {String? name, Object? data, Map<String, dynamic>? context, StackTrace? stackTrace}) =>
    loggo.logOnce(level, message, name: name, data: data, context: context, stackTrace: stackTrace);

void thr(LogLevel level, String message, Duration duration, {String? name, Object? data, Map<String, dynamic>? context, StackTrace? stackTrace}) =>
    loggo.throttle(level, message, duration, name: name, data: data, context: context, stackTrace: stackTrace);

void ddp(LogLevel level, String message, {String? name, Object? data, Map<String, dynamic>? context, StackTrace? stackTrace}) =>
    loggo.dedupe(level, message, name: name, data: data, context: context, stackTrace: stackTrace);

// Tagged logging aliases
void td(String tag, String message, {Object? data, Map<String, dynamic>? context}) =>
    loggo.tagged(tag).d(message, data: data, context: context);

void ti(String tag, String message, {Object? data, Map<String, dynamic>? context}) =>
    loggo.tagged(tag).i(message, data: data, context: context);

void ts(String tag, String message, {Object? data, Map<String, dynamic>? context}) =>
    loggo.tagged(tag).s(message, data: data, context: context);

void tw(String tag, String message, {Object? data, Map<String, dynamic>? context}) =>
    loggo.tagged(tag).w(message, data: data, context: context);

void te(String tag, String message, {Object? data, Map<String, dynamic>? context, StackTrace? stackTrace}) =>
    loggo.tagged(tag).e(message, data: data, context: context, stackTrace: stackTrace);

