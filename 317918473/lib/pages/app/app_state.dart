part of 'app_cubit.dart';

enum AppStates { initial, loading, loaded, biometrics, failedBiometrics,successBiometrics}

class AppState extends Equatable {
  final AppStates appStates;
  const AppState(this.appStates);

  AppState copyWith({final AppStates? appStates}) {
    return AppState(appStates ?? this.appStates);
  }

  @override
  List<Object> get props => [appStates];
}
