// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_wtf/entity/category.dart';
import 'package:task_wtf/pages/home_page/widgets/category_list_tile.dart';

void main() {
  testWidgets('Category list tile with empty subtitle', (tester) async {
    final category = Category(
      iconIndex: 1,
      title: 'A',
      subTitleMessage: '',
      categoryId: 33,
    );
    await tester.pumpWidget(
      wrapWidgetWithApp(
        CategoryListTile(category: category),
      ),
    );
    await tester.pumpAndSettle();
    final createFirstMessageText = find.text('No events. Click to create one.');
    expect(createFirstMessageText, findsOneWidget);
  });
  testWidgets('Category list tile with non-empty subtitle', (tester) async {
    final category = Category(
      iconIndex: 1,
      title: 'A',
      subTitleMessage: 'B',
      categoryId: 33,
    );
    await tester.pumpWidget(
      wrapWidgetWithApp(
        CategoryListTile(category: category),
      ),
    );
    await tester.pumpAndSettle();
    final createFirstMessageText = find.text('B');
    expect(createFirstMessageText, findsOneWidget);
  });
  testWidgets('Category list tile with non-empty title', (tester) async {
    final category = Category(
      iconIndex: 1,
      title: 'A',
      subTitleMessage: 'B',
      categoryId: 33,
    );
    await tester.pumpWidget(
      wrapWidgetWithApp(
        CategoryListTile(category: category),
      ),
    );
    await tester.pumpAndSettle();
    final createFirstMessageText = find.text('A');
    expect(createFirstMessageText, findsOneWidget);
  });
}

Widget wrapWidgetWithApp(Widget widget) {
  return MaterialApp(
    home: Scaffold(
      body: widget,
    ),
  );
}
