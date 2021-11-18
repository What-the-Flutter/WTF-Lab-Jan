part of 'authorization_cubit.dart';

class AuthenticationState extends Equatable {
  final bool isAuthenticated;

  const AuthenticationState({required this.isAuthenticated});

  @override
  List<Object> get props => [isAuthenticated];
}
