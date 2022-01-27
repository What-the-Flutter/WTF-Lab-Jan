import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'states_auth.dart';

class CubitAuth extends Cubit<StateAuth> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  CubitAuth() : super(StateAuth(isAuthorized: false));

  bool isAuthorizedState() {
    return state.isAuthorized;
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
        print('No user found for that email.');
      }
    }
  }
}
