import '../../models/filter_parameters.dart';

class FiltersPageState {
  final bool isColorChanged;
  final List eventPages;
  final List hashTags;
  final FilterParameters parameters;

  FiltersPageState({
    required this.isColorChanged,
    required this.eventPages,
    required this.hashTags,
    required this.parameters,
  });

  FiltersPageState copyWith({
    bool? isColorChanged,
    List? eventPages,
    List? hashTags,
    FilterParameters? parameters,
  }) {
    return FiltersPageState(
      isColorChanged: isColorChanged ?? this.isColorChanged,
      eventPages: eventPages ?? this.eventPages,
      hashTags: hashTags ?? this.hashTags,
      parameters: parameters ?? this.parameters,
    );
  }
}
