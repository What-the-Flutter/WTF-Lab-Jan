import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final localAuthentication = LocalAuthentication();

  AuthenticationCubit({bool isAuthenticated})
      : super(
          AuthenticationState(
            isAuthenticated: isAuthenticated ?? false,
          ),
        );

  void authenticate() async {
    if (state.isAuthenticated) return;
    final canCheckBiometrics = await localAuthentication.canCheckBiometrics;
    if (!canCheckBiometrics || Platform.isIOS) {
      emit(
        AuthenticationState(
          isAuthenticated: true,
        ),
      );
    }
    emit(
      AuthenticationState(
        isAuthenticated: await tryAuth(),
      ),
    );
  }

  Future<bool> tryAuth() async {
    try {
      return await localAuthentication.authenticate(
        localizedReason: 'Authentication',
        useErrorDialogs: true,
      );
    } catch (e) {
      print(e);
    }
    return false;
  }
}
