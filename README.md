# loggo

Colorful, compact, production-friendly logging for Flutter & Dart 🚀

[![pub version](https://img.shields.io/pub/v/loggo.svg)](https://pub.dev/packages/loggo)
[![pub points](https://img.shields.io/pub/points/loggo)](https://pub.dev/packages/loggo/score)
[![likes](https://img.shields.io/pub/likes/loggo)](https://pub.dev/packages/loggo/score)
[![popularity](https://img.shields.io/pub/popularity/loggo)](https://pub.dev/packages/loggo/score)

---

## ✨ Features

- **🎨 Themeable Formatters**: Choose between `fancy`, `minimal`, and `ci` themes
- **📦 Data-Only Logging**: Log structured data without a message
- **🚀 Super Compact DX**: Ultra-short aliases (`d`, `i`, `s`, `w`, `e`) and tagged logging (`'TAG'.t.i()`)
- **🛡️ Anti-Spam**: Built-in `once`, `throttle`, `dedupe` helpers
- **⏱️ Performance Measurement**: `measure()` helper to track execution time
- **💾 Sinks**: Forward logs to files or other services
- **🐦 Pure Dart/Flutter**: No runtime dependencies
- **🌐 Web Support**: ANSI colors disabled by default on web

## 📦 Installation

```yaml
dependencies:
  loggo: ^0.1.0
```

## 🚀 Quick Start

```dart
import 'package:loggo/loggo.dart';
import 'package:loggo/short.dart';

void main() {
  // Configure for development
  loggo.dev();

  // Use short aliases
  d('This is a debug message');
  i('User logged in', data: {'id': 'user-123'});
  s('Payment successful');
  w('Low on stock', data: {'item': 'milk', 'quantity': 2});
  e('Failed to fetch data', stackTrace: StackTrace.current);

  // Tagged logging
  'Auth'.t.i('User token refreshed');
  'API'.t.d('Request received', data: {'path': '/users', 'method': 'GET'});
}
```

## 🎨 Themes

### Fancy Theme (Default for Development)

```
[INFO] ℹ️ User logged in
  📎 context: {"user": "testuser"}
  📊 data: {"id": "user-123", "email": "test@example.com"}
```

### Minimal Theme

```
[INFO] I User logged in data:{"id":"user-123"} ctx:{"user":"testuser"}
```

### CI Theme (No Colors/Emojis)

```
[INFO] User logged in data:{"id":"user-123"} ctx:{"user":"testuser"}
```

## 📖 Complete Usage Guide

### Basic Logging

```dart
import 'package:loggo/loggo.dart';

// Direct usage
loggo.debug('Debug message');
loggo.info('Info message');
loggo.success('Success message');
loggo.warning('Warning message');
loggo.error('Error message');

// With data
loggo.info('User action', data: {'userId': 123, 'action': 'login'});

// With context
loggo.info('API call', context: {'requestId': 'req-123'});

// With stack trace
loggo.error('Something failed', stackTrace: StackTrace.current);
```

### Short Aliases

```dart
import 'package:loggo/short.dart';

// Ultra-short logging
d('Debug message');
i('Info message');
s('Success message');
w('Warning message');
e('Error message');

// With data
i('User logged in', data: {'id': 'user-123'});

// With context
d('Processing', context: {'step': 'validation'});
```

### Tagged Logging

```dart
// Using extension method
'Auth'.t.i('User token refreshed');
'API'.t.d('Request received', data: {'path': '/users'});
'DB'.t.e('Query failed', stackTrace: StackTrace.current);

// Using direct method
final authLogger = loggo.tagged('Auth');
authLogger.i('User authenticated');
authLogger.e('Authentication failed');
```

### Data-Only Logging

```dart
// Log structured data without a message
loggo.infoData({'user_id': '123', 'action': 'logout'});
loggo.debugData({'request': 'GET /api/users', 'duration': '150ms'});

// Tagged data logging
'API'.t.successData({'status': 200, 'data': {'item_id': 42}});
'DB'.t.infoData({'query': 'SELECT * FROM users', 'rows': 150});
```

### Anti-Spam Features

```dart
import 'package:loggo/short.dart';

// Log only the first time
once(LogLevel.info, 'Initializing service...');
once(LogLevel.info, 'Initializing service...'); // This will be ignored

// Log at most once every 2 seconds
thr(LogLevel.warning, 'Connection unstable', const Duration(seconds: 2));
thr(LogLevel.warning, 'Connection unstable', const Duration(seconds: 2)); // This will be ignored

// Don't log consecutive duplicate messages
ddp(LogLevel.debug, 'Processing item #1');
ddp(LogLevel.debug, 'Processing item #1'); // This will be ignored
ddp(LogLevel.debug, 'Processing item #2'); // This will be logged
```

### Performance Measurement

```dart
// Measure execution time
final result = await m('database query', () async {
  await Future.delayed(const Duration(milliseconds: 150));
  return 'query result';
});

// Direct usage
final result = await loggo.measure('API call', () async {
  return await fetchData();
});
```

### Configuration

```dart
// Development configuration (fancy theme, debug level)
loggo.dev();

// Production configuration (minimal theme, info level)
loggo.prod();

// Quiet configuration (CI theme, error level only)
loggo.quiet();

// Custom configuration
loggo.configure(LoggerConfig(
  minLevel: LogLevel.warning,
  enableColors: true,
  enableReleaseLogging: true,
  formatter: AnsiLogFormatter.theme(const AnsiThemeData.fancy()),
));
```

### Custom Themes

```dart
// Create custom theme
final customTheme = const AnsiThemeData.fancy().copyWith(
  emoji: {LogLevel.info: '🚀'},
  colors: {LogLevel.error: AnsiColor.red},
);

loggo.configure(LoggerConfig(
  formatter: AnsiLogFormatter.theme(customTheme),
));
```

### Sinks (Log Forwarding)

```dart
// File sink with rotation
final fileSink = RollingFileSink('./app.log', maxFileSize: 1024 * 1024, maxFiles: 5);
loggo.addSink(fileSink);

// Sampling sink (log only 50% of info messages)
final samplingSink = SamplingSink(fileSink, rates: {LogLevel.info: 0.5});
loggo.addSink(samplingSink);

// Rate limiting sink (max 10 logs per minute)
final rateLimitSink = RateLimitSink(fileSink, const Duration(minutes: 1), 10);
loggo.addSink(rateLimitSink);

// Custom sink
loggo.addSink((LogRecord record) {
  // Send to external service
  sendToExternalService(record.toJson());
});
```

### Log Levels

| Level     | Value | Description                       |
| --------- | ----- | --------------------------------- |
| Debug     | 700   | Development debugging information |
| Info      | 800   | General information messages      |
| Success   | 800   | Success confirmations             |
| Warning   | 900   | Warning messages                  |
| Error     | 1000  | Error messages                    |
| HandRaise | 700   | Hand raise events                 |
| Meeting   | 700   | Meeting-related events            |
| Network   | 700   | Network-related logs              |

### Advanced Features

#### Object Logging Extension

```dart
// Log any object with its type as the logger name
final user = {'id': 123, 'name': 'John'};
user.tl('User data processed'); // Uses 'Map<String, int>' as logger name
```

#### Stream Support

```dart
// Listen to all log records
loggo.stream.listen((LogRecord record) {
  print('Received log: ${record.message}');
});
```

#### Context and Data

```dart
// Context is for metadata that doesn't change often
loggo.info('Processing request', context: {'userId': 123, 'sessionId': 'abc'});

// Data is for the actual payload
loggo.info('API response', data: {'status': 200, 'body': responseData});
```

## 🎯 Best Practices

### 1. Use Appropriate Log Levels

```dart
// Debug: Detailed information for debugging
d('Parsing JSON response', data: {'raw': jsonString});

// Info: General information about program execution
i('User logged in', data: {'userId': 123});

// Success: Successful operations
s('Payment processed', data: {'amount': 99.99});

// Warning: Something unexpected but not critical
w('API rate limit approaching', data: {'remaining': 5});

// Error: Error conditions
e('Database connection failed', stackTrace: StackTrace.current);
```

### 2. Use Tagged Logging for Modules

```dart
// Instead of this
loggo.info('Auth: User token refreshed');

// Use this
'Auth'.t.i('User token refreshed');
```

### 3. Use Anti-Spam Features

```dart
// For initialization messages
once(LogLevel.info, 'Service initialized');

// For frequent warnings
thr(LogLevel.warning, 'High memory usage', const Duration(seconds: 30));

// For duplicate prevention
ddp(LogLevel.debug, 'Processing item ${item.id}');
```

### 4. Use Data-Only Logging for Structured Data

```dart
// Instead of this
loggo.info('User data: ${user.toJson()}');

// Use this
loggo.infoData(user.toJson());
```

## 🔧 Configuration Options

### LoggerConfig Properties

- `minLevel`: Minimum log level to display
- `enableColors`: Whether to use ANSI colors
- `enableReleaseLogging`: Whether to log in release builds
- `formatter`: Custom log formatter

### Theme Customization

```dart
final theme = const AnsiThemeData.fancy().copyWith(
  emoji: {
    LogLevel.info: '🚀',
    LogLevel.error: '💥',
  },
  colors: {
    LogLevel.warning: AnsiColor.yellow,
    LogLevel.error: AnsiColor.red,
  },
);
```

## 📊 Comparison with Other Loggers

| Feature         | loggo          | logger      | talker      | loggy       |
| --------------- | -------------- | ----------- | ----------- | ----------- |
| **Theming**     | ✅ (3 presets) | ✅ (custom) | ✅ (custom) | ✅ (custom) |
| **Data-Only**   | ✅             | ❌          | ✅          | ❌          |
| **Compact DX**  | ✅ (opt-in)    | ❌          | ❌          | ✅          |
| **Anti-Spam**   | ✅             | ❌          | ✅          | ❌          |
| **No deps**     | ✅             | ✅          | ✅          | ✅          |
| **Web Support** | ✅             | ✅          | ✅          | ✅          |

## 📝 Notes

- **Web**: ANSI colors are disabled by default on the web
- **File Sink**: The `RollingFileSink` is skipped on the web
- **Performance**: Logging is disabled in release builds unless `enableReleaseLogging` is true
- **Memory**: Log records are not stored in memory by default (use sinks for persistence)

## 📜 License

This package is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## ☕️ Support

If you like loggo, consider buying me a coffee ❤️

[Your BuyMeACoffee Link Here]

## 👨‍💻 Author

This package was created by Phạm Thanh Thiện and will be upgraded and greatly enhanced over time.
