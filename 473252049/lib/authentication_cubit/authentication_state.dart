part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  final bool isAuthenticated;

  const AuthenticationState({this.isAuthenticated});

  @override
  List<Object> get props => [isAuthenticated];
}
