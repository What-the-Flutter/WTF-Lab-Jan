import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final localAuth = LocalAuthentication();

  AuthCubit()
      : super(
          AuthState(
            isAuth: false,
            counterAttempt: 0,
          ),
        );

  void authenticate() async {
    final bool = await localAuth.authenticate(
      localizedReason: 'Please authenticate',
      biometricOnly: true,
      useErrorDialogs: true,
    );
    emit(
      state.copyWith(
        isAuth: bool,
        counterAttempt: state.counterAttempt + 1,
      ),
    );
  }
}
