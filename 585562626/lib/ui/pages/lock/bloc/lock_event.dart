import 'package:equatable/equatable.dart';

abstract class LockEvent extends Equatable {
  const LockEvent();

  @override
  List<Object> get props => [];
}

class AuthenticateEvent extends LockEvent {
  final bool isAuthenticated;

  AuthenticateEvent({required this.isAuthenticated});

  @override
  List<Object> get props => [isAuthenticated];
}
