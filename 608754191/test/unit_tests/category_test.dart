import 'package:flutter_test/flutter_test.dart';
import 'package:task_wtf/entity/category.dart';

void main() {
  group('Category test ', () {
    test('convert to map with id', () {
      final expected = {
        'category_id': 7,
        'title': 'A',
        'sub_tittle_name': 'B',
        'category_icon_index': 1,
      };
      final category = Category(
        iconIndex: 1,
        title: 'A',
        subTitleMessage: 'B',
        categoryId: 7,
      );
      expect(
        category.convertCategoryToMapWithId(),
        expected,
      );
    });
    test('convert to map without id', () {
      final expected = {
        'title': 'A',
        'sub_tittle_name': 'B',
        'category_icon_index': 1,
      };
      final category = Category(
        iconIndex: 1,
        title: 'A',
        subTitleMessage: 'B',
      );
      expect(
        category.convertCategoryToMap(),
        expected,
      );
    });
    test('convert category from map', () {
      final map = {
        'title': 'C',
        'sub_tittle_name': 'D',
        'category_icon_index': 12,
        'category_id': 23,
      };
      final category = Category(
        iconIndex: 12,
        title: 'C',
        subTitleMessage: 'D',
        categoryId: 23,
      );
      expect(
        category,
        Category.fromMap(map),
      );
    });
  });
}
