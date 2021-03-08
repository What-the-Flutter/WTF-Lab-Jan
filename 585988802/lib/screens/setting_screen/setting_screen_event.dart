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
