// part of 'chat_cubit.dart';
//
// class ChatState extends Equatable {
//   final List<int>? isSelected;
//   final bool isSearchMode;
//   final bool isEditMode;
//   final Category category;
//   final Section? section;
//   final Category? migrateCategory;
//   final Category? migrateSection;
//
//   ChatState({
//     required this.category,
//     this.isSelected,
//     this.isSearchMode = false,
//     this.isEditMode = false,
//     this.migrateCategory,
//     this.migrateSection,
//     this.section,
//   });
//
//   ChatState copyWith({
//     List<int>? isSelected,
//     required bool isSearchMode,
//     required bool isEditMode,
//     required Category category,
//     Section? section,
//     Category? migrateCategory,
//     Category? migrateSection,
//   }) {
//     return ChatState(
//       category: category,
//       isSelected: isSelected ?? this.isSelected,
//       isSearchMode: isSearchMode,
//       isEditMode: isEditMode,
//       section: section ?? this.section,
//       migrateCategory: migrateCategory ?? this.migrateCategory,
//       migrateSection: migrateSection ?? this.migrateSection,
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//         category,
//         isSelected,
//         isSearchMode,
//         isEditMode,
//         section,
//         migrateCategory,
//         migrateSection,
//       ];
// }
