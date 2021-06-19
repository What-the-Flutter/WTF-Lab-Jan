import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../services/databases/db_category.dart';
import '../../services/local_auth.dart';
import '../../services/shared_prefs.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final localAuth = LocalAuth();
  AppCubit() : super(AppState(AppStates.initial)) {
    init();
  }

  Future<void> init() async {
    emit(state.copyWith(appStates: AppStates.loading));
    await DBProvider.init();
    await MySharedPreferences.sharedPrefs.init();
    await checkForSupporting();
    if (MySharedPreferences.sharedPrefs.isBiometricAuth ?? false) {
      emit(state.copyWith(appStates: AppStates.biometrics));
      emit(state.copyWith(appStates: AppStates.loading));
    } else {
      emit(state.copyWith(appStates: AppStates.loaded));
    }
  }

  Future<void> checkForSupporting() async {
    if (MySharedPreferences.sharedPrefs.containBiometricAuth) {
      return;
    }
    final isDeviceSupported = await localAuth.isDeviceSupported;
    final isCheckBiometrics = await localAuth.checkBiometrics;
    if (isCheckBiometrics && isDeviceSupported) {
      MySharedPreferences.sharedPrefs.setBiometricAuth(false);
    }
  }

  void onAuthResult(bool isAuthSuccess) {
    if (isAuthSuccess) {
      emit(state.copyWith(appStates: AppStates.successBiometrics));
    } else {
      emit(state.copyWith(appStates: AppStates.failedBiometrics));
    }
  }
}
