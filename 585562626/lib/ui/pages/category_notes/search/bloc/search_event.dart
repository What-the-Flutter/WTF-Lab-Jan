import 'package:cool_notes/models/note.dart';
import 'package:equatable/equatable.dart';

import '../../../../../models/tag.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class InitStateEvent extends SearchEvent {
  final List<Note> notes;
  final List<Tag> tags;

  InitStateEvent(this.notes, this.tags);

  @override
  List<Object?> get props => [notes, tags];
}

class TagTapEvent extends SearchEvent {
  final Tag tag;

  TagTapEvent(this.tag);

  @override
  List<Object?> get props => [tag];
}
