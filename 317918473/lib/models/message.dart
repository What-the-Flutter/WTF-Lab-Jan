import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../repository/tags_repository.dart';

class Messages extends Equatable {
  final String id;
  final String categoryId;
  final DateTime createAt;
  final String? message;
  final String? pathImage;
  final bool isEdit;
  final bool isFavorite;
  final bool isSelect;
  final IconData tag;

  Messages({
    required this.id,
    required this.createAt,
    required this.categoryId,
    this.message,
    this.pathImage,
    this.isEdit = false,
    this.isFavorite = false,
    this.isSelect = false,
    this.tag = Icons.home,
  });

  @override
  List<Object?> get props => [
        id,
        categoryId,
        createAt,
        message,
        pathImage,
        isEdit,
        isFavorite,
        isSelect
      ];

  Messages copyWith({
    String? id,
    String? categoryId,
    DateTime? createAt,
    String? message,
    String? pathImage,
    bool? isEdit,
    bool? isFavorite,
    bool? isSelect,
    IconData? tag,
  }) {
    return Messages(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      createAt: createAt ?? this.createAt,
      message: message ?? this.message,
      pathImage: pathImage ?? this.pathImage,
      isEdit: isEdit ?? this.isEdit,
      isFavorite: isFavorite ?? this.isFavorite,
      isSelect: isSelect ?? this.isSelect,
      tag: tag ?? this.tag,
    );
  }

  factory Messages.fromMap(Map<String, dynamic> map) {
    return Messages(
      id: map['id'],
      categoryId: map['category_id'],
      createAt: DateTime.tryParse(map['create_at']) ?? DateTime.now(),
      message: map['message'],
      pathImage: map['path_image'],
      isEdit: map['is_edit'] == 0 ? false : true,
      isSelect: map['is_selected'] == 0 ? false : true,
      isFavorite: map['is_favorite'] == 0 ? false : true,
      tag: tagFromString(map['tag']) ?? Icons.home,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'create_at': createAt.toIso8601String(),
      'message': message,
      'path_image': pathImage,
      'is_edit': isEdit == false ? 0 : 1,
      'is_selected': isSelect == false ? 0 : 1,
      'is_favorite': isFavorite == false ? 0 : 1,
      'tag': tag.toString()
    };
  }

  static IconData? tagFromString(String tag) {
    final list = TagRepository().list;
    return list.firstWhere((element) => element.toString() == tag);
  }
}
