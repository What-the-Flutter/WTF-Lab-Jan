import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/repository/theme_repository.dart';
import '../data/theme/custom_theme.dart';

part 'general_options_state.dart';

class GeneralOptionsCubit extends Cubit<GeneralOptionsState> {
  final ThemeRepository themeRepository;

  GeneralOptionsCubit({
    this.themeRepository,
    int index,
  }) : super(
          GeneralOptionsState(
            themeType: ThemeType.values[index],
            currentTheme: themeRepository.themes[index],
            isDateTimeModification: false,
            isLeftBubbleAlign: false,
            isCenterDateBubble: false,
            isAuthentication: false,
          ),
        );

  void toggleTheme() {
    if (state.themeType == ThemeType.dark) {
      emit(
        state.copyWith(
          themeType: ThemeType.light,
          currentTheme: themeRepository.themes[ThemeType.light.index],
        ),
      );
    } else if (state.themeType == ThemeType.light) {
      emit(
        state.copyWith(
          themeType: ThemeType.dark,
          currentTheme: themeRepository.themes[ThemeType.dark.index],
        ),
      );
    }
  }

  void changeBubbleAlign(bool value) {
    emit(state.copyWith(isLeftBubbleAlign: value));
  }

  void changeDateTimeModification(bool value) {
    emit(state.copyWith(isDateTimeModification: value));
  }

  void changeCenterDateBubble(bool value) {
    emit(state.copyWith(isCenterDateBubble: value));
  }
  void changeAuthentication(bool value) {
    emit(state.copyWith(isAuthentication: value));
  }
}
