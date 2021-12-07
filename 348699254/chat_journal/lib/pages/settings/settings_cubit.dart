import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/settings_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsCubit(this.settingsRepository)
      : super(
    SettingsState(
      isCategoryListOpen: true,
    ),
  );

  void initSettings() {
    _setAbilityChooseCategory();
  }

  void _setAbilityChooseCategory() {
    final isCategoryListOpen = settingsRepository.abilityChooseCategory();
    emit(
      state.copyWith(
        isCategoryListOpen: isCategoryListOpen,
      ),
    );
  }

  void changeAbilityChooseCategory() {
    settingsRepository.changeAbilityChooseCategory(!state.isCategoryListOpen);
    emit(
      state.copyWith(
        isCategoryListOpen: !state.isCategoryListOpen,
      ),
    );
  }
}
