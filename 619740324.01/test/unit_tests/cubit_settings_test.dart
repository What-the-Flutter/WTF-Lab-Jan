import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:my_project/pages/settings_page/cubit_general_settings.dart';
import 'package:my_project/pages/settings_page/states_general_settings.dart';

void main() {
  late CubitGeneralSettings cubitGeneralSettings;

  setUp(() {
    cubitGeneralSettings = CubitGeneralSettings();
  });

  blocTest<CubitGeneralSettings, StatesGeneralSettings>(
    'emits settings state when resetAllSettings() is called',
    build: () => CubitGeneralSettings(),
    seed: () => StatesGeneralSettings(
      isDateTimeModification: true,
      isBubbleAlignment: true,
      isCenterDateBubble: true,
    ),
    act: (cubit) => cubit.resetAllPreferences(),
    expect: () => <dynamic>[
      StatesGeneralSettings(
        isDateTimeModification: true,
        isBubbleAlignment: false,
        isCenterDateBubble: true,
      ),
      StatesGeneralSettings(
        isDateTimeModification: false,
        isBubbleAlignment: false,
        isCenterDateBubble: true,
      ),
      StatesGeneralSettings(
        isDateTimeModification: false,
        isBubbleAlignment: false,
        isCenterDateBubble: false,
      ),
    ],
  );
}
