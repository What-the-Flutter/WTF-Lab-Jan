import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  AuthCubit()
      : super(
          AuthState(
            isAuthorized: false,
            isLoading: false,
            canCheckBiometrics: false,
            listOfBiometrics: [],
          ),
        );

  bool isAuthorizedState() {
    return state.isAuthorized;
  }

  Future<void> authorizeWithBiometric() async {
    var isAuthorized = false;
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
      print('err');
      print(isAuthorized);
      print(e);
    }
  }

  Future<void> checkBiometrics() async {
    var canCheckBiometric = false;
    try {
      canCheckBiometric = await _localAuthentication.canCheckBiometrics;
      print(canCheckBiometric);
      emit(
        state.copyWith(canCheckBiometrics: canCheckBiometric),
      );
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> getListOfBiometricTypes() async {
    var availableListOfBiometrics =
        await _localAuthentication.getAvailableBiometrics();
    try {
      availableListOfBiometrics =
          await _localAuthentication.getAvailableBiometrics();
      print(availableListOfBiometrics);
      emit(
        state.copyWith(listOfBiometrics: availableListOfBiometrics),
      );
    } on PlatformException catch (e) {
      print(e);
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
          .signInWithEmailAndPassword(email: email, password: password);
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
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
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
      //print(isAuthorized);
      emit(
        state.copyWith(
          isAuthorized: isAuthorized,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
