import 'package:equatable/equatable.dart';

import 'category.dart';
import 'note.dart';

class NoteWithCategory extends Equatable {
  final Note note;
  final Category category;

  NoteWithCategory({
    required this.note,
    required this.category,
  });

  @override
  List<Object?> get props => [note, category];
}
