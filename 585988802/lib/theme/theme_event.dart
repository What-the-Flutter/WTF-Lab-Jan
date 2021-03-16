abstract class ThemeEvent {
  const ThemeEvent();
}

class ChangeThemeEvent extends ThemeEvent {
  const ChangeThemeEvent();
}

class InitThemeEvent extends ThemeEvent {
  const InitThemeEvent();
}

class ResetThemeEvent extends ThemeEvent {
  const ResetThemeEvent();
}
