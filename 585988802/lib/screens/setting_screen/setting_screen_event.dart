abstract class SettingScreenEvent {
  const SettingScreenEvent();
}

class InitSettingScreenEvent extends SettingScreenEvent {
  const InitSettingScreenEvent();
}

class ChangeBubbleAlignmentEvent extends SettingScreenEvent {
  const ChangeBubbleAlignmentEvent();
}

class ChangeDateTimeModificationEvent extends SettingScreenEvent {
  const ChangeDateTimeModificationEvent();
}

class ChangeFontSizeEvent extends SettingScreenEvent {
  final int selectedFontSize;

  const ChangeFontSizeEvent(this.selectedFontSize);
}

class ResetSettingsEvent extends SettingScreenEvent {
  const ResetSettingsEvent();
}
