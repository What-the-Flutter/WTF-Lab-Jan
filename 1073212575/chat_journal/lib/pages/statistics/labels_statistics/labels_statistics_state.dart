import '../../../models/filter_parameters.dart';

class LabelsStatisticsPageState {
  final List labels;
  final List messages;
  final String selectedPeriod;
  final int selectedLabelIndex;
  final FilterParameters parameters;

  LabelsStatisticsPageState({
    required this.labels,
    required this.messages,
    required this.selectedPeriod,
    required this.selectedLabelIndex,
    required this.parameters,
  });

  LabelsStatisticsPageState copyWith({
    List? labels,
    List? messages,
    String? selectedPeriod,
    int? selectedLabelIndex,
    FilterParameters? parameters,
  }) {
    return LabelsStatisticsPageState(
      labels: labels ?? this.labels,
      messages: messages ?? this.messages,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      selectedLabelIndex: selectedLabelIndex ?? this.selectedLabelIndex,
      parameters: parameters ?? this.parameters,
    );
  }
}
