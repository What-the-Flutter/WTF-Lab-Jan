import 'package:flutter/cupertino.dart';

class Category {
  final String assetImage;
  final String descripton;
  final String title;
  final ChatMessages chatMessages = ChatMessages();

  Category(this.assetImage, this.descripton, this.title);

  static final list = [
    Category(
        'assets/img/Rectangle 231.png', 'descrtiption about forest', 'Forest'),
    Category(
        'assets/img/Rectangle 252.png', 'descrtiption about forest', 'Forest'),
    Category(
        'assets/img/Rectangle 263.png', 'descrtiption about forest', 'Forest'),
    Category(
        'assets/img/Rectangle 284.png', 'descrtiption about forest', 'Forest'),
    Category(
        'assets/img/Rectangle 231.png', 'descrtiption about forest', 'Forest'),
    Category(
        'assets/img/Rectangle 252.png', 'descrtiption about forest', 'Forest'),
    Category(
        'assets/img/Rectangle 263.png', 'descrtiption about forest', 'Forest'),
    Category(
        'assets/img/Rectangle 284.png', 'descrtiption about forest', 'Forest'),
  ];
}

class ChatMessages extends ChangeNotifier {
  final List<Messages> _messages = [];
  List<Messages> get messages => _messages;

  void add(String value) {
    final date = DateTime.now();
    final message = Messages(date, message: value);
    _messages.add(message);
    notifyListeners();
  }

  void delete(int index) {
    _messages.removeAt(index);
    notifyListeners();
  }

  void update(int index, String message) {
    _messages[index].message = message;
    notifyListeners();
  }

  void removeFavorite(int index) {
    _messages[index].isFavorite = false;
  }

  void addFavorite(int index) {
    _messages[index].isFavorite = true;
  }

  void sendImage(String path) {
    final date = DateTime.now();
    final message = Messages(date, path: path);
    _messages.add(message);
    notifyListeners();
  }
}

class Messages {
  final DateTime _date;
  String? _message;
  String? path;
  bool isEdit = false;
  bool isFavorite = false;

  Messages(DateTime date, {String? message, this.path})
      : _date = date,
        _message = message;

  set message(String message) => _message = message;
  String get message => _message ?? '';
  DateTime get date => _date;

  void edit() => isEdit = true;

  void favorite() => isFavorite = !isFavorite;
}
