import 'package:equatable/equatable.dart';

import '../models/message.dart';

class ChatRepository extends Equatable {
  final List<Messages> _messages = [];
  List<Messages> get messages => _messages;

  void add(String value) {
    final date = DateTime.now();
    final message = Messages(date, message: value);
    _messages.add(message);
  }

  void delete(int index) {
    _messages.removeAt(index);
  }

  void update(int index, String message) {
    _messages[index] =
        _messages[index].copyWith(message: message, isEdit: true);
  }

  void favorite(int index) {
    _messages[index] =
        _messages[index].copyWith(isFavorite: !_messages[index].isFavorite);
  }

  void sendImage(String path) {
    final date = DateTime.now();
    final message = Messages(date, pathImage: path);
    _messages.add(message);
  }

  void select(int index) {
    _messages[index] =
        _messages[index].copyWith(isSelect: !_messages[index].isSelect);
  }

  void unselectAll() {
    for (var i = 0; i < _messages.length; i++) {
      _messages[i] = _messages[i].copyWith(isSelect: false);
    }
  }

  void addMessages(List<Messages> list) {
    _messages.addAll(list);
    print(_messages);
  }

  @override
  List<Object?> get props => [_messages];
}
