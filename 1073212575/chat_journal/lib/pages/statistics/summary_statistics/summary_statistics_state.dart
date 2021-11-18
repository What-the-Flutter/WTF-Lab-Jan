import 'package:chat_journal/models/char_data.dart';
import 'package:chat_journal/models/filter_parameters.dart';

class SummaryStatisticsPageState {
  final bool isGraphicVisible;
  final List labels;
  final List messages;
  final String selectedPeriod;
  final int selectedLabelIndex;
  final FilterParameters parameters;
  final  List<ColumnChartData> summaryData;

  SummaryStatisticsPageState({
    required this.isGraphicVisible,
    required this.labels,
    required this.messages,
    required this.selectedPeriod,
    required this.selectedLabelIndex,
    required this.parameters,
    required this.summaryData,
  });

  SummaryStatisticsPageState copyWith({
    bool? isGraphicVisible,
    List? labels,
    List? messages,
    String? selectedPeriod,
    int? selectedLabelIndex,
    FilterParameters? parameters,
    List<ColumnChartData>? summaryData,
  }) {
    return SummaryStatisticsPageState(
      isGraphicVisible:isGraphicVisible??this.isGraphicVisible,
      labels: labels ?? this.labels,
      messages: messages ?? this.messages,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      selectedLabelIndex: selectedLabelIndex ?? this.selectedLabelIndex,
      parameters: parameters ?? this.parameters,
      summaryData: summaryData ?? this.summaryData,
    );
  }
}
