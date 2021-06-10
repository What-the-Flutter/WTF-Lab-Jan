// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:test/test.dart';
import '../models/category.dart';
import '../repository/chat_repositore.dart';

void main() {
  test('test', () {
    final repo = ChatRepository();
    //repo.add('value1');
    //repo.add('value1');
    // repo.select(0);
    // repo.select(1);
    expect(repo.messages[0].isSelect, true);
    expect(repo.messages[1].isSelect, true);
    repo.unselectAll();
    expect(repo.messages[0].isSelect, false);
    expect(repo.messages[1].isSelect, false);
  });

  test('categories string', () {
    print(Categories.forest.toString());
  });
}
