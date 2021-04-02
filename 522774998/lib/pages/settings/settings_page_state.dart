part of 'settings_page_cubit.dart';

class SettingsPageState {
  bool isDateModificationSwitched = false;
  bool isBubbleAlignmentSwitched = false;
  bool isDateAlignmentSwitched = false;
  double fontSize = 16;
  int indexBackground = 0;

  SettingsPageState({
    this.isBubbleAlignmentSwitched,
    this.isDateAlignmentSwitched,
    this.isDateModificationSwitched,
    this.fontSize,
    this.indexBackground,
  });

  SettingsPageState copyWith({
    bool isBubbleAlignmentSwitched,
    bool isDateAlignmentSwitched,
    bool isDateModificationSwitched,
    double fontSize,
    int indexBackground,
  }) {
    return SettingsPageState(
      isBubbleAlignmentSwitched:
          isBubbleAlignmentSwitched ?? this.isBubbleAlignmentSwitched,
      isDateAlignmentSwitched:
          isDateAlignmentSwitched ?? this.isDateAlignmentSwitched,
      isDateModificationSwitched:
          isDateModificationSwitched ?? this.isDateModificationSwitched,
      fontSize: fontSize ?? this.fontSize,
      indexBackground: indexBackground ?? this.indexBackground,
    );
  }

  @override
  String toString() {
    return 'SettingsPageState{isBubbleAlignmentSwitched: $isBubbleAlignmentSwitched'
        'isDateAlignmentSwitched: $isDateAlignmentSwitched,'
        'isDateModificationSwitched: $isDateModificationSwitched,'
        'fontSize: $fontSize,'
        'indexBackground: $indexBackground}';
  }
}
