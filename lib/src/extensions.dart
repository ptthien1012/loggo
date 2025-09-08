import 'core_logger.dart';
import 'tagged_logger.dart';

extension StringTagExtension on String {
  TaggedLogger get t => Loggo.instance.tagged(this);
}

extension ObjectLogExtension on Object {
  void tl(String message, {LogLevel level = LogLevel.debug}) =>
      Loggo.instance.log(level, message, name: runtimeType.toString(), data: this);
}

