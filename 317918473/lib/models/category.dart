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
  final int id;
  final String assetImage;
  final String descripton;
  final String title;
  final Categories categories;
  final bool isPin;
  final repository = ChatRepository();

  Category(
      this.id, this.assetImage, this.descripton, this.title, this.categories,
      {this.isPin = false});

  @override
  List<Object> get props => [id, descripton, title, categories, isPin];

  Category copyWith({
    String? assetImage,
    String? descripton,
    String? title,
    Categories? categories,
    bool? isPin,
  }) {
    return Category(
      id,
      assetImage ?? this.assetImage,
      descripton ?? this.descripton,
      title ?? this.title,
      categories ?? this.categories,
      isPin: isPin ?? this.isPin,
    );
  }
}
