import 'package:chat_journal/models/char_data.dart';
import 'package:chat_journal/models/filter_parameters.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartsStatisticsPageState {
  final bool isGraphicVisible;
  final List labels;
  final List messages;
  final List selectedLabels;
  final String selectedPeriod;
  final int selectedLabelIndex;
  final FilterParameters parameters;
  final List<List<ChartData>> summaryData;
  final List<ChartSeries<dynamic, dynamic>> series;

  ChartsStatisticsPageState({
    required this.isGraphicVisible,
    required this.labels,
    required this.messages,
    required this.selectedLabels,
    required this.selectedPeriod,
    required this.selectedLabelIndex,
    required this.parameters,
    required this.summaryData,
    required this.series,
  });

  ChartsStatisticsPageState copyWith({
    bool? isGraphicVisible,
    List? labels,
    List? messages,
    List? selectedLabels,
    String? selectedPeriod,
    int? selectedLabelIndex,
    FilterParameters? parameters,
    List<List<ChartData>>? summaryData,
    List<ChartSeries<dynamic, dynamic>>? series,
  }) {
    return ChartsStatisticsPageState(
      isGraphicVisible: isGraphicVisible ?? this.isGraphicVisible,
      labels: labels ?? this.labels,
      messages: messages ?? this.messages,
      selectedLabels: selectedLabels ?? this.selectedLabels,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      selectedLabelIndex: selectedLabelIndex ?? this.selectedLabelIndex,
      parameters: parameters ?? this.parameters,
      summaryData: summaryData ?? this.summaryData,
      series: series ?? this.series,
    );
  }
}
