part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final bool isAuth;
  final int counterAttempt;

  AuthState({
    this.isAuth,
    this.counterAttempt,
  });

  @override
  List<Object> get props => [isAuth, counterAttempt];

  AuthState copyWith({
    final bool isAuth,
    final int counterAttempt,
  }) {
    return AuthState(
      isAuth: isAuth ?? this.isAuth,
      counterAttempt: counterAttempt ?? this.counterAttempt,
    );
  }
}
