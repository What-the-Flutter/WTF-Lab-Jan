import '../../../models/filter_parameters.dart';

class StatisticsFiltersPageState {
  final bool isColorChanged;
  final List eventPages;
  final FilterParameters parameters;

  StatisticsFiltersPageState({
    required this.isColorChanged,
    required this.eventPages,
    required this.parameters,
  });

  StatisticsFiltersPageState copyWith({
    bool? isColorChanged,
    List? eventPages,
    FilterParameters? parameters,
  }) {
    return StatisticsFiltersPageState(
      isColorChanged: isColorChanged ?? this.isColorChanged,
      eventPages: eventPages ?? this.eventPages,
      parameters: parameters ?? this.parameters,
    );
  }
}
