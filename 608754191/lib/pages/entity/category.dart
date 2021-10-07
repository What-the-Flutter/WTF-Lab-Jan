import 'package:equatable/equatable.dart';

class Category extends Equatable {
  int? categoryId;
  int iconIndex;
  String title;
  String subTitleMessage;

  Category({
    this.categoryId,
    required this.iconIndex,
    required this.title,
    required this.subTitleMessage,
  });

  Map<String, dynamic> convertCategoryToMapWithId() {
    return {
      'category_id': categoryId,
      'title': title,
      'category_icon_index': iconIndex,
      'sub_tittle_name': subTitleMessage,
    };
  }

  Map<String, dynamic> convertCategoryToMap() {
    return {
      'title': title,
      'category_icon_index': iconIndex,
      'sub_tittle_name': subTitleMessage,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryId: map['category_id'],
      title: map['title'],
      iconIndex: map['category_icon_index'],
      subTitleMessage: map['sub_tittle_name'],
    );
  }

  @override
  List<Object?> get props => [title, iconIndex, categoryId, subTitleMessage];
}
