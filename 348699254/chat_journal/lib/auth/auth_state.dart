class AuthState {
  final bool isAuthorized;
  final bool isLoading;
  final bool canCheckBiometrics;
  final List listOfBiometrics;

  AuthState({
    required this.isAuthorized,
    required this.isLoading,
    required this.canCheckBiometrics,
    required this.listOfBiometrics,
  });

  AuthState copyWith({
    bool? isAuthorized,
    bool? isLoading,
    bool? canCheckBiometrics,
    List? listOfBiometrics,
  }) {
    return AuthState(
      isAuthorized: isAuthorized ?? this.isAuthorized,
      isLoading: isLoading ?? this.isLoading,
      canCheckBiometrics: canCheckBiometrics ?? this.canCheckBiometrics,
      listOfBiometrics: listOfBiometrics ?? this.listOfBiometrics,
    );
  }
}
