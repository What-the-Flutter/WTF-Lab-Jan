import 'package:flutter_test/flutter_test.dart';
import 'package:task_wtf/entity/message.dart';

void main() {
  group('Message test ', () {
    test('convert to map with id', () {
      final expected = {
        'message_id': 3,
        'current_category_id': 2,
        'text': 'A',
        'image_path': '123',
        'time': '21:53',
        'bookmark_index': 1,
      };
      final message = Message(
        text: 'A',
        currentCategoryId: 2,
        time: '21:53',
        messageId: 3,
        bookmarkIndex: 1,
        imagePath: '123',
      );
      expect(
        message.convertMessageToMapWithId(),
        expected,
      );
    });
    test('convert to map without id', () {
      final expected = {
        'current_category_id': 1432,
        'text': 'B',
        'image_path': '456',
        'time': '21:57',
        'bookmark_index': 1,
      };
      final message = Message(
        text: 'B',
        currentCategoryId: 1432,
        time: '21:57',
        bookmarkIndex: 1,
        imagePath: '456',
      );
      expect(
        message.convertMessageToMap(),
        expected,
      );
    });
  });
}
