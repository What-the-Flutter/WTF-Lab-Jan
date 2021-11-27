class FilterParameters {
  final bool onlyCheckedMessages;
  final bool isDateSelected;
  final bool arePagesIgnored;
  final List selectedPages;
  final List selectedTags;
  final List selectedLabels;
  final String searchText;
  final DateTime date;

  FilterParameters({
    required this.onlyCheckedMessages,
    required this.isDateSelected,
    required this.arePagesIgnored,
    required this.selectedPages,
    required this.selectedTags,
    required this.selectedLabels,
    required this.searchText,
    required this.date,
  });

  FilterParameters copyWith({
    bool? onlyCheckedMessages,
    bool? isDateSelected,
    bool? arePagesIgnored,
    List? selectedPages,
    List? selectedTags,
    List? selectedLabels,
    String? searchText,
    DateTime? date,
  }) {
    return FilterParameters(
      onlyCheckedMessages: onlyCheckedMessages ?? this.onlyCheckedMessages,
      isDateSelected: isDateSelected ?? this.isDateSelected,
      arePagesIgnored: arePagesIgnored ?? this.arePagesIgnored,
      selectedPages: selectedPages ?? this.selectedPages,
      selectedTags: selectedTags ?? this.selectedTags,
      selectedLabels: selectedLabels ?? this.selectedLabels,
      searchText: searchText ?? this.searchText,
      date: date ?? this.date,
    );
  }
}
