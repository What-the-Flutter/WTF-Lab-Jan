part of 'setting_page_cubit.dart';

class SettingsPageState extends Equatable {
  bool isDateModificationSwitched = false;
  bool isBubbleAlignmentSwitched = false;
  bool isDateAlignmentSwitched = false;

  SettingsPageState({
    this.isBubbleAlignmentSwitched,
    this.isDateAlignmentSwitched,
    this.isDateModificationSwitched,
  });

  SettingsPageState copyWith({
    bool isBubbleAlignmentSwitched,
    bool isDateAlignmentSwitched,
    bool isDateModificationSwitched,
  }) {
    return SettingsPageState(
      isBubbleAlignmentSwitched: isBubbleAlignmentSwitched ?? this.isBubbleAlignmentSwitched,
      isDateAlignmentSwitched: isDateAlignmentSwitched ?? this.isDateAlignmentSwitched,
      isDateModificationSwitched: isDateModificationSwitched ?? this.isDateModificationSwitched,
    );
  }

  @override
  String toString() {
    return 'SettingsPageState{isBubbleAlignmentSwitched: $isBubbleAlignmentSwitched'
        'isDateAlignmentSwitched: $isDateAlignmentSwitched,'
        'isDateModificationSwitched: $isDateModificationSwitched}';
  }

  @override
  List<Object> get props => [
    isBubbleAlignmentSwitched,
    isDateAlignmentSwitched,
    isDateModificationSwitched,
  ];
}
