import 'package:beauty_logger/beauty_logger.dart';

void main() {
  // --- Basic Logging ---
  AppLogger.info('User logged in successfully');
  AppLogger.success('Data saved to the database');
  AppLogger.warning('API rate limit approaching');
  AppLogger.error('Failed to connect to the server');
  AppLogger.debug('Processing user input');

  // --- Logging with Data ---
  AppLogger.info('User profile updated', data: {
    'userId': 123,
    'changes': ['name', 'email'],
  });

  // --- JSON Logging ---
  final userData = {
    'id': 1,
    'name': 'John Doe',
    'settings': {'theme': 'dark', 'notifications': true},
  };
  AppLogger.json('User data received', userData);

  // --- Special Categories ---
  AppLogger.network('API call completed', data: {
    'endpoint': '/api/users',
    'status': 200,
    'duration': '245ms',
  });

  AppLogger.meeting('Meeting started', data: {
    'participants': 5,
    'duration': '30min',
  });

  AppLogger.handRaise('User raised hand', data: {
    'userId': 'user123',
    'timestamp': DateTime.now().toIso8601String(),
  });

  // --- Error with Stack Trace ---
  try {
    throw Exception('Something went wrong!');
  } catch (e, stackTrace) {
    AppLogger.error(
      'An unexpected error occurred',
      data: {'error': e.toString()},
      stackTrace: stackTrace,
    );
  }
}

