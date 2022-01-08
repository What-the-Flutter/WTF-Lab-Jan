import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  AuthCubit()
      : super(
          AuthState(
            isAuthorized: false,
            isLoading: false,
            canCheckBiometrics: false,
            listOfBiometrics: [],
          ),
        );

  Future<void> authorizeWithBiometric() async {
    var isAuthorized = false;
    if (checkBiometrics() == true) {
      try {
        isAuthorized = await _localAuthentication.authenticate(
          biometricOnly: true,
          localizedReason: 'Please authenticate to complete your transaction',
          useErrorDialogs: true,
          stickyAuth: true,
        );
        emit(
          state.copyWith(isAuthorized: isAuthorized),
        );
      } on PlatformException catch (e) {
        logger.e(e.code);
      }
    } else {
      logger.e('No biometrics found');
    }
  }

  Future<bool> checkBiometrics() async {
    var canCheckBiometrics = false;
    try {
      canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      print(canCheckBiometrics);
      emit(
        state.copyWith(canCheckBiometrics: canCheckBiometrics),
      );
    } on PlatformException catch (e) {
      logger.e(e.code);
    }
    return canCheckBiometrics;
  }

  Future<void> getListOfBiometricTypes() async {
    try {
      final availableListOfBiometrics =
          await _localAuthentication.getAvailableBiometrics();
      logger.i(availableListOfBiometrics);
      emit(
        state.copyWith(listOfBiometrics: availableListOfBiometrics),
      );
    } on PlatformException catch (e) {
      logger.e(e.code);
    }
  }

  void loadingState(bool loadingState) {
    emit(
      state.copyWith(isLoading: loadingState),
    );
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    var isAuthorized = false;
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        isAuthorized = true;
      }
      emit(
        state.copyWith(
          isAuthorized: isAuthorized,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        logger.e('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        logger.e('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signInAnonymously() async {
    var isAuthorized = false;
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      if (userCredential.user != null) {
        isAuthorized = true;
      }
      emit(
        state.copyWith(
          isAuthorized: isAuthorized,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        logger.e('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        logger.e('Wrong password provided for that user.');
      }
    }
  }
}
