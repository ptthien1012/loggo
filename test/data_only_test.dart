import 'package:flutter_test/flutter_test.dart';
import 'package:loggo/loggo.dart';

import 'test_helpers.dart';

void main() {
  group('Data-Only Test', () {
    test('infoData/debugData should not crash when message is empty', () {
      final testSink = TestSink();
      loggo.addSink(testSink);

      loggo.infoData({'key': 'value'});
      loggo.debugData(['item1', 'item2']);

      expect(testSink.records.length, 2);
      expect(testSink.records[0].message, '');
      expect(testSink.records[1].message, '');

      loggo.clearSinks();
    });

    test("'TAG'.t.i() should not crash when message is empty", () {
      final testSink = TestSink();
      loggo.addSink(testSink);

      'TAG'.t.i('Test message');
      'TAG'.t.infoData({'key': 'value'});

      expect(testSink.records.length, 2);
      expect(testSink.records[0].name, 'TAG');
      expect(testSink.records[1].name, 'TAG');
      expect(testSink.records[1].message, '');

      loggo.clearSinks();
    });
  });
}

