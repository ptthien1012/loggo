import 'dart:convert';
import 'package:beauty_logger/src/log_formatter.dart';
import 'package:beauty_logger/src/log_record.dart';
import 'package:beauty_logger/beauty_logger.dart';

/// Default log formatter that uses ANSI escape codes for colors.
class AnsiLogFormatter extends LogFormatter {
  static const String _reset = '\x1B[0m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _red = '\x1B[31m';
  static const String _cyan = '\x1B[36m';
  static const String _blue = '\x1B[34m';
  static const String _magenta = '\x1B[35m';
  static const String _white = '\x1B[37m';
  static const String _gray = '\x1B[90m';

  @override
  String format(LogRecord record) {
    final color = _getColorForLevel(record.level);
    final icon = _getIconForLevel(record.level);

    String formattedMessage =
        '$color$icon [${record.level.name}] ${record.message}$_reset';

    if (record.data != null) {
      final formattedData = _formatJson(record.data);
      formattedMessage += '\n$formattedData';
    }

    return formattedMessage;
  }

  String _getColorForLevel(LogLevel level) {
    switch (level) {
      case LogLevel.info:
      case LogLevel.success:
        return _green;
      case LogLevel.warning:
        return _yellow;
      case LogLevel.error:
        return _red;
      case LogLevel.debug:
        return _cyan;
      case LogLevel.handRaise:
        return _blue;
      case LogLevel.meeting:
        return _magenta;
      case LogLevel.network:
        return _white;
    }
  }

  String _getIconForLevel(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.success:
        return '✅';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
      case LogLevel.debug:
        return '🔍';
      case LogLevel.handRaise:
        return '🙋';
      case LogLevel.meeting:
        return '🎯';
      case LogLevel.network:
        return '🌐';
    }
  }

  String _formatJson(Object? data) {
    if (data == null) return '${_gray}null$_reset';

    try {
      dynamic jsonData = data;
      if (data is String) {
        try {
          jsonData = jsonDecode(data);
        } catch (_) {
          return data;
        }
      }

      if (jsonData is Map || jsonData is List) {
        return _colorizeJson(jsonData);
      }

      return data.toString();
    } catch (e) {
      return '${_red}Error formatting JSON: $e$_reset';
    }
  }

  String _colorizeJson(dynamic json, [String indent = '']) {
    if (json is String) {
      try {
        final decoded = jsonDecode(json);
        return _colorizeJson(decoded, indent);
      } catch (e) {
        return '$_green"$json"$_reset';
      }
    }
    if (json is num) return '$_blue$json$_reset';
    if (json is bool) return '$_magenta$json$_reset';
    if (json == null) return '${_gray}null$_reset';

    final nextIndent = '$indent  ';

    if (json is Map) {
      final entries = json.entries.map((entry) {
        final key = '$_yellow"${entry.key}"$_reset';
        final value = _colorizeJson(entry.value, nextIndent);
        return '$nextIndent$key: $value';
      });
      return '$_white{\n${entries.join(',\n')}\n$indent}$_reset';
    }

    if (json is List) {
      final items =
          json.map((item) => '$nextIndent${_colorizeJson(item, nextIndent)}');
      return '$_white[\n${items.join(',\n')}\n$indent]$_reset';
    }

    return json.toString();
  }
}

