import 'package:flutter/cupertino.dart';

class CategoryList extends ChangeNotifier {
  final _list = <Category>[];
  List<Category> get list => _list;

  void add(Categories categories, String desc, String name) {
    final category = chooseCategory(categories, desc, name);
    _list.add(category);
    notifyListeners();
  }

  void remove(int index) {
    list.removeAt(index);
    notifyListeners();
  }

  void update(int index, String desc, String name, Categories categories) {
    list[index] = chooseCategory(categories, desc, name);
    notifyListeners();
  }

  void pin(int index) {
    if (list[index].isPin) {
      list[index].isPin = false;
    } else {
      list[index].isPin = true;
    }
    notifyListeners();
  }

  Category chooseCategory(
      Categories categories, String description, String name) {
    switch (categories) {
      case Categories.forest:
        return Category(categories.img, description, name, categories);
      case Categories.grasslands:
        return Category(categories.img, description, name, categories);
      case Categories.taiga:
        return Category(categories.img, description, name, categories);
      case Categories.tundra:
        return Category(categories.img, description, name, categories);
      default:
        throw 'category choose is null';
    }
  }
}

enum Categories { forest, taiga, tundra, grasslands }

extension CategoriesExtension on Categories {
  String get img {
    switch (this) {
      case Categories.forest:
        return 'assets/img/Rectangle 231.png';
      case Categories.taiga:
        return 'assets/img/Rectangle 252.png';
      case Categories.tundra:
        return 'assets/img/Rectangle 263.png';
      case Categories.grasslands:
        return 'assets/img/Rectangle 284.png';
    }
  }
}

class Category {
  final String assetImage;
  final String descripton;
  final String title;
  final Categories categories;
  bool isPin;
  final ChatMessages chatMessages = ChatMessages();

  Category(this.assetImage, this.descripton, this.title, this.categories,
      {this.isPin = false});
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
