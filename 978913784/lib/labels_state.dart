import 'entity/label.dart';

class LabelsState {
  final List<Label> labels;

  LabelsState(this.labels);

  LabelsState copyWith({List<Label> labels}) =>
      LabelsState(labels ?? this.labels);

  static Label labelById(List<Label> labels, int id) {
    for (var label in labels) {
      if (label.id == id) return label;
    }
    return null;
  }
}