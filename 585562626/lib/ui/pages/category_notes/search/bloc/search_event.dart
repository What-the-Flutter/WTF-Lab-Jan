import 'package:equatable/equatable.dart';

import '../../../../../models/note.dart';
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

class QueryChangedEvent extends SearchEvent {
  final String query;

  QueryChangedEvent(this.query);

  @override
  List<Object?> get props => [query];
}
