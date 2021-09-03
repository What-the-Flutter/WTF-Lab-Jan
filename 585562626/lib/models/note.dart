import 'package:equatable/equatable.dart';

enum AlignDirection { right, left }

class Note extends Equatable {
  final int? id;
  final DateTime created;
  final AlignDirection direction;
  final bool hasStar;
  final DateTime? updated;
  final String? text;
  final String? image;

  Note({
    this.id,
    required this.direction,
    this.hasStar = false,
    this.text,
    this.image,
    this.updated,
    DateTime? created,
  }) : created = created ?? DateTime.now();

  Note copyWith({int? id, bool? hasStar, String? text, String? image, DateTime? createdAt}) {
    return Note(
      id: id ?? this.id,
      direction: direction,
      hasStar: hasStar ?? this.hasStar,
      text: text ?? this.text,
      image: image ?? this.image,
      created: createdAt ?? created,
      updated: DateTime.now(),
    );
  }

  @override
  String toString() {
    return '$text';
  }

  @override
  List<Object?> get props => [id, direction, hasStar, text, image, updated, created];
}
