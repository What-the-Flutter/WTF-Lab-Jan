import 'package:equatable/equatable.dart';

import 'note_tag_model.dart';

class Note extends Equatable {
  final int? id;
  final DateTime created;
  final bool hasStar;
  final DateTime? updated;
  final String? text;
  final String? image;
  final NoteTag? noteTag;

  Note({
    this.id,
    this.hasStar = false,
    this.text,
    this.image,
    this.updated,
    this.noteTag,
    DateTime? created,
  }) : created = created ?? DateTime.now();

  Note copyWith({
    int? id,
    bool? hasStar,
    String? text,
    String? image,
    NoteTag? noteTag,
    DateTime? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      hasStar: hasStar ?? this.hasStar,
      text: text ?? this.text,
      image: image ?? this.image,
      created: createdAt ?? created,
      noteTag: noteTag ?? this.noteTag,
      updated: DateTime.now(),
    );
  }

  @override
  String toString() {
    return '$text';
  }

  @override
  List<Object?> get props => [
        id,
        hasStar,
        text,
        image,
        updated,
        created,
        noteTag,
      ];
}
