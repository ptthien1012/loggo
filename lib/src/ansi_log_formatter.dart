import 'dart:convert';

import 'ansi_theme.dart';
import 'core_logger.dart';
import 'log_formatter.dart';
import 'log_record.dart';

class AnsiLogFormatter extends LogFormatter {
  final AnsiThemeData theme;
  final int maxDepth;
  final int maxBytes;
  final int previewList;
  final int previewMapKeys;
  final Set<String> redactKeys;
  final List<String> keyPriority;

  AnsiLogFormatter.theme(
    this.theme, {
    this.maxDepth = 5,
    this.maxBytes = 8 * 1024, // 8k
    this.previewList = 8,
    this.previewMapKeys = 12,
    this.redactKeys = const {'password', 'token', 'authorization', 'secret'},
    this.keyPriority = const ['id', 'type', 'status', 'message', 'code'],
  });

  @override
  String format(LogRecord record) {
    final sb = StringBuffer();
    final color = theme.colors[record.level] ?? '';
    final emoji = theme.emoji[record.level] ?? '';

    // Header
    sb.write('$color[${_levelName(record.level)}]');
    if (emoji.isNotEmpty) sb.write(' $emoji');
    if (record.message.isNotEmpty) sb.write(' ${record.message}');
    if (color.isNotEmpty) sb.write(AnsiColors.reset);

    if (theme.prettySpacing) sb.writeln();

    // Context, Data, StackTrace
    _append(sb, 'context', record.context, theme.prettySpacing);
    _append(sb, 'data', record.data, theme.prettySpacing);
    _append(sb, 'stack', record.stackTrace?.toString(), theme.prettySpacing);

    return sb.toString();
  }

  void _append(StringBuffer sb, String key, Object? value, bool pretty) {
    if (value == null) return;
    if (pretty) {
      final prefix = {'context': '📎', 'data': '📦', 'stack': '🧵'}[key] ?? key;
      sb.write('  $prefix $key: ');
      sb.writeln(_prettyJson(value));
    } else {
      final prefix =
          {'context': 'ctx', 'data': 'data', 'stack': 'stack'}[key] ?? key;
      sb.write(' $prefix:${_compactJson(value)}');
    }
  }

  String _levelName(LogLevel level) =>
      level.toString().split('.').last.toUpperCase();

  String _prettyJson(Object? data) {
    try {
      final redactedData = _jsonPreview(data, 0);
      final encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(redactedData);
    } catch (e) {
      return data.toString();
    }
  }

  String _compactJson(Object? data) {
    try {
      final redactedData = _jsonPreview(data, 0);
      final encoder = JsonEncoder();
      return encoder.convert(redactedData);
    } catch (e) {
      return data.toString();
    }
  }

  Object? _jsonPreview(Object? value, int depth) {
    if (depth > maxDepth) return '... (depth limit)';
    if (value is Map) {
      if (depth > 0 && value.isEmpty) return '{}';
      final sortedKeys = value.keys.toList()
        ..sort((a, b) {
          final ia = keyPriority.indexOf(a.toString());
          final ib = keyPriority.indexOf(b.toString());
          if (ia != -1 && ib != -1) return ia.compareTo(ib);
          if (ia != -1) return -1;
          if (ib != -1) return 1;
          return a.toString().compareTo(b.toString());
        });

      final entries = sortedKeys.map((k) {
        if (redactKeys.contains(k.toString().toLowerCase())) {
          return MapEntry(k, theme.redactReplacement);
        }
        return MapEntry(k, _jsonPreview(value[k], depth + 1));
      });

      if (sortedKeys.length > previewMapKeys) {
        return Map.fromEntries([
          ...entries.take(previewMapKeys),
          MapEntry('...', '${sortedKeys.length - previewMapKeys} more keys'),
        ]);
      }
      return Map.fromEntries(entries);
    }
    if (value is List) {
      if (depth > 0 && value.isEmpty) return '[]';
      if (value.length > previewList) {
        return [
          ...value.take(previewList).map((e) => _jsonPreview(e, depth + 1)),
          '... (${value.length - previewList} more items)'
        ];
      }
      return value.map((e) => _jsonPreview(e, depth + 1)).toList();
    }
    if (value is String) {
      if (value.length > maxBytes) {
        return '${value.substring(0, maxBytes)}... (+${value.length - maxBytes} chars)';
      }
    }
    return value;
  }
}
