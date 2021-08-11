import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/category.dart';
import '../../../models/note.dart';

abstract class CategoryNotesEvent extends Equatable {
  const CategoryNotesEvent();

  @override
  List<Object?> get props => [];
}

abstract class NoteEvent extends CategoryNotesEvent {
  final BaseNote note;

  NoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}

class FetchNotesEvent extends CategoryNotesEvent {
  FetchNotesEvent();
}

class AddNoteEvent extends CategoryNotesEvent {
  final AlignDirection direction;

  AddNoteEvent({String? image, String? text, required this.direction}) : super();

  @override
  List<Object?> get props => [direction];
}

class SwitchStarEvent extends CategoryNotesEvent {
  const SwitchStarEvent();
}

class UpdateNoteEvent extends CategoryNotesEvent {
  const UpdateNoteEvent();
}

class DeleteSelectedNotesEvent extends CategoryNotesEvent {
  const DeleteSelectedNotesEvent();
}

class SwitchEditingModeEvent extends CategoryNotesEvent {
  const SwitchEditingModeEvent();
}

class SwitchNoteSelectionEvent extends NoteEvent {
  SwitchNoteSelectionEvent(BaseNote note) : super(note);
}

class StartEditingEvent extends CategoryNotesEvent {
  const StartEditingEvent();
}

class ImageSelectedEvent extends CategoryNotesEvent {
  final PickedFile image;

  ImageSelectedEvent(this.image);

  @override
  List<Object?> get props => [image];
}

class ImagePickerClosedEvent extends CategoryNotesEvent {
  const ImagePickerClosedEvent();
}

class TextChangedEvent extends CategoryNotesEvent {
  final String text;

  TextChangedEvent(this.text);

  @override
  List<Object?> get props => [text];
}
