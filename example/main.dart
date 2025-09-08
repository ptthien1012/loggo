import 'package:loggo/loggo.dart';
import 'package:loggo/short.dart';

void main() {
  // Configure for development
  loggo.dev();

  // --- Basic Logging ---
  d('This is a debug message');
  i('User logged in', data: {'id': 'user-123', 'email': 'test@example.com'});
  s('Payment successful', data: {'amount': 99.99, 'currency': 'USD'});
  w('Low on stock', data: {'item': 'milk', 'quantity': 2});
  e('Failed to fetch data', stackTrace: StackTrace.current);

  // --- Tagged Logging ---
  'Auth'.t.i('User token refreshed');
  'API'.t.d('Request received', data: {'path': '/users', 'method': 'GET'});

  // --- Data-Only Logging ---
  loggo.infoData({'user_id': '123', 'action': 'logout'});
  'API'.t.successData({
    'status': 200,
    'data': {'item_id': 42}
  });

  // --- Anti-Spam & Measurement ---
  once(LogLevel.info, 'Initializing service...');
  once(LogLevel.info, 'Initializing service...'); // This will be ignored

  thr(LogLevel.warning, 'Connection unstable', const Duration(seconds: 2));
  thr(LogLevel.warning, 'Connection unstable',
      const Duration(seconds: 2)); // This will be ignored

  ddp(LogLevel.debug, 'Processing item #1');
  ddp(LogLevel.debug, 'Processing item #1'); // This will be ignored
  ddp(LogLevel.debug, 'Processing item #2');

  m('database query', () async {
    await Future.delayed(const Duration(milliseconds: 150));
  });
}
