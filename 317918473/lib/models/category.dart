import 'package:equatable/equatable.dart';
import '../repository/chat_repositore.dart';

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

class Category extends Equatable {
  final String id;
  final String assetImage;
  final String description;
  final String title;
  final Categories categories;
  final bool isPin;
  final repository = ChatRepository();

  Category({
    required this.id,
    required this.assetImage,
    required this.description,
    required this.title,
    required this.categories,
    this.isPin = false,
  });

  @override
  List<Object> get props => [id, description, title, categories, isPin];

  Category copyWith({
    String? id,
    String? assetImage,
    String? description,
    String? title,
    Categories? categories,
    bool? isPin,
  }) {
    return Category(
      id: id ?? this.id,
      assetImage: assetImage ?? this.assetImage,
      description: description ?? this.description,
      title:title ?? this.title,
      categories:categories ?? this.categories,
      isPin: isPin ?? this.isPin,
    );
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id:map['id'],
      assetImage:map['assert_image'],
      description:map['description'],
      title:map['title'],
      categories:categoriesFromString(map['categories']),
      isPin: map['pinned'] == 0 ? false : true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assert_image': assetImage,
      'description': description,
      'title': title,
      'categories': categories.toString(),
      'pinned': isPin == false ? 0 : 1,
    };
  }

  static Categories categoriesFromString(String categories) {
    if (categories == Categories.forest.toString()) {
      return Categories.forest;
    } else if (categories == Categories.taiga.toString()) {
      return Categories.taiga;
    } else if (categories == Categories.tundra.toString()) {
      return Categories.tundra;
    } else {
      return Categories.grasslands;
    }
  }
}
