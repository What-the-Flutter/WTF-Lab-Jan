import 'package:equatable/equatable.dart';

class StatesCreatePage extends Equatable {
  final int selectedIndex;
  final bool isWriting;
  final bool isEditing;

  StatesCreatePage({
    this.selectedIndex = 0,
    this.isWriting = false,
    this.isEditing = false,
  });

  StatesCreatePage copyWith({
    int? selectedIndex,
    bool? isWriting,
    bool? isEditing,
  }) {
    return StatesCreatePage(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isEditing: isEditing ?? this.isEditing,
      isWriting: isWriting ?? this.isWriting,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, isWriting, isEditing];
}
