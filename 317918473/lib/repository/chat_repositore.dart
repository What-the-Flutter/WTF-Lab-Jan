import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../models/message.dart';
import '../services/databases/db_chat.dart';

class ChatRepository extends Equatable {
  final db = DBChat.instance;
  final List<Messages> _messages = [];
  List<Messages> get messages => _messages;

  Future<List<Messages>> getAll(String categoryId) async {
    final listFromDB = await db.getAllMessages(categoryId);
    _messages.addAll(listFromDB);
    return _messages;
  }

  void add(String value, String categoryId, IconData tag) {
    final date = DateTime.now();
    final message = Messages(
      id: Uuid().v1(),
      categoryId: categoryId,
      createAt: date,
      message: value,
      tag: tag,
    );
    _messages.add(message);
    db.add(message);
  }

  void delete(Messages messages) {
    _messages.removeWhere((element) => element.id == messages.id);
    db.delete(messages.id);
  }

  void update(Messages messages, String message) {
    final updated = messages.copyWith(message: message);
    final index = _messages.indexWhere((element) => element.id == messages.id);
    _messages[index] = updated;
    db.update(messages);
  }

  void favorite() {
    final selectedList = _messages.where((element) => element.isSelect).map(
      (item) {
        print(item);
        final index = _messages.indexWhere((element) => element.id == item.id);
        _messages[index] = item.copyWith(isFavorite: !item.isFavorite);
        return _messages[index];
      },
    ).toList();
    print(selectedList);
    db.favorite(selectedList);
  }

  void sendImage(String path, String categoryId, IconData tag) {
    final date = DateTime.now();
    final message = Messages(
      id: Uuid().v1(),
      categoryId: categoryId,
      createAt: date,
      pathImage: path,
      tag: tag,
    );
    _messages.add(message);
  }

  void select(Messages messages) {
    final index = _messages.indexWhere((element) => element.id == messages.id);
    _messages[index] = _messages[index].copyWith(isSelect: !messages.isSelect);
  }

  void unselectAll() {
    for (var i = 0; i < _messages.length; i++) {
      _messages[i] = _messages[i].copyWith(isSelect: false);
    }
  }

  void addMessages(List<Messages> list) {
    _messages.addAll(list);
  }

  @override
  List<Object> get props => [_messages];
}
