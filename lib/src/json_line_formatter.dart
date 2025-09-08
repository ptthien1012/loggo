import 'dart:convert';

import 'log_formatter.dart';
import 'log_record.dart';

class JsonLineFormatter extends LogFormatter {
  const JsonLineFormatter();

  @override
  String format(LogRecord record) {
    return jsonEncode(record.toJson());
  }
}

