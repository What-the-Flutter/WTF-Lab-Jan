part of 'notes_cubit.dart';

class NotesState extends Equatable {
  final DateTime updateTime;
  final bool isEditMode;
  final Category category;
  final List<Note> notes;
  final List<Note> selectedNotes;
  final PickedFile? image;
  final String? text;
  final bool showImagePicker;
  final bool showTags;
  final Category selectedCategory;

  NotesState({
    required this.updateTime,
    this.isEditMode = false,
    required this.category,
    required this.notes,
    required this.selectedNotes,
    this.image,
    required this.selectedCategory,
    this.text,
    this.showImagePicker = false,
    this.showTags = false,
  });

  NotesState copyWith({
    bool? isEditMode,
    Category? category,
    List<Note>? notes,
    List<Note>? selectedNotes,
    PickedFile? image,
    String? text,
    bool? showImagePicker,
    bool? showTags,
    Category? selectedCategory,
    DateTime? updateTime,
  }) {
    return NotesState(
      isEditMode: isEditMode ?? this.isEditMode,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      selectedNotes: selectedNotes ?? this.selectedNotes,
      image: image ?? this.image,
      text: text ?? this.text,
      showImagePicker: showImagePicker ?? this.showImagePicker,
      showTags: showTags ?? this.showTags,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      updateTime: updateTime ?? this.updateTime,
    );
  }

  @override
  List<Object?> get props => [
        isEditMode,
        category,
        notes,
        selectedNotes,
        image,
        text,
        showImagePicker,
        showTags,
        updateTime,
        selectedCategory,
      ];
}
