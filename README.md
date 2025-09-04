# BeautyLogger 🎨

A beautiful and enhanced Flutter logger with colors, JSON formatting, and proper debug console support. Features multiple log levels, emoji icons, and colorized output for better debugging experience.

## Features ✨

- **🎨 Colorized Output**: Different colors for different log levels
- **📊 Multiple Log Levels**: Debug, Info, Success, Warning, Error, and custom levels
- **🔍 JSON Formatting**: Pretty-printed JSON with syntax highlighting
- **⚡ Performance**: Only logs in debug mode, zero overhead in release
- **🎯 Categorized Logging**: Special categories for meetings, network calls, and hand-raise events
- **📋 Stack Trace Support**: Full stack trace support for error logging
- **🌐 VSCode Integration**: Optimized for VSCode debug console

## Getting Started 🚀

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  beauty_logger: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage 📖

Import the package:

```dart
import 'package:beauty_logger/beauty_logger.dart';
```

### Basic Logging

```dart
// Info messages (green with ℹ️ icon)
AppLogger.info('User logged in successfully');

// Success messages (green with ✅ icon)
AppLogger.success('Data saved to database');

// Warning messages (yellow with ⚠️ icon)
AppLogger.warning('API rate limit approaching');

// Error messages (red with ❌ icon)
AppLogger.error('Failed to connect to server');

// Debug messages (cyan with 🔍 icon)
AppLogger.debug('Processing user input');
```

### Logging with Data

```dart
// Log with additional data
AppLogger.info('User profile updated', data: {
  'userId': 123,
  'changes': ['name', 'email']
});

// Log with custom name
AppLogger.error('Database error',
  name: 'DB_SERVICE',
  data: {'query': 'SELECT * FROM users'}
);
```

### JSON Logging

```dart
// Pretty-print JSON data
final userData = {
  'id': 1,
  'name': 'John Doe',
  'settings': {
    'theme': 'dark',
    'notifications': true
  }
};

AppLogger.json('User data received', userData);
```

### Special Categories

```dart
// Network requests (white with 🌐 icon)
AppLogger.network('API call completed', data: {
  'endpoint': '/api/users',
  'status': 200,
  'duration': '245ms'
});

// Meeting events (magenta with 🎯 icon)
AppLogger.meeting('Meeting started', data: {
  'participants': 5,
  'duration': '30min'
});

// Hand raise events (blue with 🙋 icon)
AppLogger.handRaise('User raised hand', data: {
  'userId': 'user123',
  'timestamp': DateTime.now().toIso8601String()
});
```

### Error Logging with Stack Trace

```dart
try {
  // Some risky operation
  await riskyOperation();
} catch (e, stackTrace) {
  AppLogger.error('Operation failed',
    data: {'error': e.toString()},
    stackTrace: stackTrace
  );
}
```

## Log Levels 📊

| Level     | Icon | Color   | Description                       |
| --------- | ---- | ------- | --------------------------------- |
| Debug     | 🔍   | Cyan    | Development debugging information |
| Info      | ℹ️   | Green   | General information messages      |
| Success   | ✅   | Green   | Success confirmations             |
| Warning   | ⚠️   | Yellow  | Warning messages                  |
| Error     | ❌   | Red     | Error messages                    |
| Network   | 🌐   | White   | Network-related logs              |
| Meeting   | 🎯   | Magenta | Meeting-related events            |
| HandRaise | 🙋   | Blue    | Hand raise events                 |

## Performance ⚡

BeautyLogger is designed with performance in mind:

- Only active in debug mode (`kDebugMode`)
- Zero overhead in release builds
- Efficient JSON formatting
- Minimal memory footprint

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
# beauty_logger
