import 'package:bloc_test/bloc_test.dart';
import 'package:chat_journal_cubit/data/repository/settings_repository.dart';
import 'package:chat_journal_cubit/pages/settings/settings_cubit.dart';
import 'package:chat_journal_cubit/pages/settings/settings_state.dart';
import 'package:chat_journal_cubit/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  mainCubit();
}

void mainCubit() {
  late SettingsCubit settingsCubit;
  late SettingsRepository settingsRepository;

  setUp(() {
    settingsRepository = MockSettingsRepository();
    settingsCubit = SettingsCubit(settingsRepository);
  });

  group('SettingsCubit', () {
    blocTest<SettingsCubit, SettingsState>(
      'emits isCategoryListOpen when angeAbilityChooseCategory() is called',
      build: () => SettingsCubit(settingsRepository),
      seed: () => SettingsState(
        isCategoryListOpen: false,
        isBiometricAuth: true,
        isLightTheme: true,
        isRightBubbleAlignment: true,
        smallFontSize: 12,
        mediumFontSize: 16,
        largeFontSize: 18,
        chosenFontSize: 16,
        themeData: ThemeData(),
      ),
      act: (cubit) => cubit.changeAbilityChooseCategory(),
      expect: () => <Matcher>[
        isA<SettingsState>()
            .having((s) => s.isCategoryListOpen, 'isCategoryListOpen', true)
      ],
    );
    blocTest<SettingsCubit, SettingsState>(
      'emits settings state when resetAllSettings() is called',
      build: () => SettingsCubit(settingsRepository),
      seed: () => SettingsState(
        isCategoryListOpen: false,
        isBiometricAuth: false,
        isLightTheme: false,
        isRightBubbleAlignment: false,
        smallFontSize: 12,
        mediumFontSize: 16,
        largeFontSize: 18,
        chosenFontSize: 16,
        themeData: ThemeData(),
      ),
      act: (cubit) => cubit.resetAllSettings(),
      expect: () => <Matcher>[
        isA<SettingsState>()
            .having((s) => s.isCategoryListOpen, 'isCategoryListOpen', true)
            .having((s) => s.isBiometricAuth, 'isBiometricAuth', true)
            .having((s) => s.isCategoryListOpen, 'isBiometricAuth', true)
            .having((s) => s.isLightTheme, 'isLightTheme', true)
            .having(
                (s) => s.isRightBubbleAlignment, 'isRightBubbleAlignment', true)
            .having((s) => s.chosenFontSize, 'chosenFontSize', 16)
            .having((s) => s.themeData, 'themeData', lightTheme)
      ],
    );
    blocTest<SettingsCubit, SettingsState>(
      'emits chosenFontSize when changeFontSize() is called',
      build: () => SettingsCubit(settingsRepository),
      seed: () => SettingsState(
        isCategoryListOpen: false,
        isBiometricAuth: false,
        isLightTheme: false,
        isRightBubbleAlignment: false,
        smallFontSize: 12,
        mediumFontSize: 16,
        largeFontSize: 18,
        chosenFontSize: 16,
        themeData: ThemeData(),
      ),
      act: (cubit) => cubit.changeFontSize(18),
      expect: () => <Matcher>[
        isA<SettingsState>()
            .having((s) => s.chosenFontSize, 'chosenFontSize', 18)
      ],
    );
  });
}
