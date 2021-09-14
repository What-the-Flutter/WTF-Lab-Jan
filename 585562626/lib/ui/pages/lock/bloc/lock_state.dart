import 'package:equatable/equatable.dart';

class LockState extends Equatable {
  final bool? authenticated;

  const LockState({this.authenticated});

  LockState copyWith({bool? authenticated}) {
    return LockState(
      authenticated: authenticated ?? this.authenticated,
    );
  }

  @override
  List<Object?> get props => [authenticated];
}
