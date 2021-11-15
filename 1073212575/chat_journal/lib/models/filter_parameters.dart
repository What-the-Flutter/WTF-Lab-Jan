class FilterParameters {
  final bool onlyCheckedMessages;
  final bool isDateSelected;
  final bool arePagesIgnored;
  final List selectedPages;
  final List selectedTags;
  final List selectedCategories;
  final String searchText;
  final DateTime date;

  FilterParameters({
    required this.onlyCheckedMessages,
    required this.isDateSelected,
    required this.arePagesIgnored,
    required this.selectedPages,
    required this.selectedTags,
    required this.selectedCategories,
    required this.searchText,
    required this.date,
  });

  FilterParameters copyWith({
    bool? onlyCheckedMessages,
    bool? isDateSelected,
    bool? arePagesIgnored,
    List? selectedPages,
    List? selectedTags,
    List? selectedCategories,
    String? searchText,
    DateTime? date,
  }) {
    return FilterParameters(
      onlyCheckedMessages: onlyCheckedMessages ?? this.onlyCheckedMessages,
      isDateSelected: isDateSelected ?? this.isDateSelected,
      arePagesIgnored: arePagesIgnored ?? this.arePagesIgnored,
      selectedPages: selectedPages ?? this.selectedPages,
      selectedTags: selectedTags ?? this.selectedTags,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      searchText: searchText ?? this.searchText,
      date: date ?? this.date,
    );
  }
}
