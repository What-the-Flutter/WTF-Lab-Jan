import '../../../entity/label.dart';

class LabelsState {
  final List<Label> added;

  LabelsState(this.added);

  LabelsState copyWith({List<Label> added}) => LabelsState(added ?? this.added);
}
