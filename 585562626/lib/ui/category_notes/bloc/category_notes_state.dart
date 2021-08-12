import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/category.dart';
import '../../../models/note.dart';

class CategoryNotesState extends Equatable {
  final bool isEditingMode;
  final bool startedUpdating;
  final NoteCategory category;
  final List<Note> notes;
  final List<Note> selectedNotes;
  final PickedFile? image;
  final String? text;
  final bool showImagePicker;

  CategoryNotesState({
    this.isEditingMode = false,
    this.startedUpdating = false,
    required this.category,
    this.notes = const [],
    this.selectedNotes = const [],
    this.image,
    this.text,
    this.showImagePicker = false,
  });

  CategoryNotesState copyWith(
      {bool? isEditingMode,
      bool? startedUpdating,
      List<Note>? notes,
      List<Note>? selectedNotes,
      PickedFile? image,
      String? text,
      bool? showImagePicker,
      bool? textCopiedToClipboard}) {
    return CategoryNotesState(
      isEditingMode: isEditingMode ?? this.isEditingMode,
      startedUpdating: startedUpdating ?? this.startedUpdating,
      category: category,
      notes: notes ?? this.notes,
      selectedNotes: selectedNotes ?? this.selectedNotes,
      image: image ?? this.image,
      text: text ?? this.text,
      showImagePicker: showImagePicker ?? this.showImagePicker,
    );
  }

  CategoryNotesState resetImage() {
    return CategoryNotesState(
      isEditingMode: isEditingMode,
      startedUpdating: startedUpdating,
      category: category,
      notes: notes,
      selectedNotes: selectedNotes,
      image: null,
      text: text,
      showImagePicker: showImagePicker,
    );
  }

  @override
  List<Object?> get props => [
        isEditingMode,
        startedUpdating,
        category,
        notes,
        selectedNotes,
        image,
        text,
        showImagePicker,
      ];
}
