import 'dart:io';

import '../core_logger.dart';
import '../json_line_formatter.dart';
import '../log_record.dart';

class RollingFileSink extends LogSink {
  final String _path;
  final int _maxFileSize;
  final int _maxFiles;
  final JsonLineFormatter _formatter;
  File? _file;
  IOSink? _ioSink;

  RollingFileSink(
    this._path, {
    int maxFileSize = 1024 * 1024, // 1MB
    int maxFiles = 5,
  })  : _maxFileSize = maxFileSize,
        _maxFiles = maxFiles,
        _formatter = const JsonLineFormatter();

  @override
  void call(LogRecord record) {
    if (_isWeb()) return;

    _ensureOpen();
    _ioSink?.writeln(_formatter.format(record));
    _rotateIfNeeded();
  }

  bool _isWeb() {
    try {
      // Try to detect if we're running on web
      return false; // Default to false for non-web platforms
    } catch (e) {
      return true; // If there's an error, assume web
    }
  }

  void _ensureOpen() {
    if (_file == null) {
      _file = File(_path);
      if (!_file!.existsSync()) {
        _file!.createSync(recursive: true);
      }
      _ioSink = _file!.openWrite(mode: FileMode.append);
    }
  }

  void _rotateIfNeeded() {
    if (_file != null && _file!.lengthSync() > _maxFileSize) {
      _ioSink?.close();
      for (int i = _maxFiles - 1; i > 0; i--) {
        final oldFile = File('$_path.$i');
        if (oldFile.existsSync()) {
          oldFile.renameSync('$_path.${i + 1}');
        }
      }
      _file!.renameSync('$_path.1');
      _file = null;
      _ioSink = null;
    }
  }
}
