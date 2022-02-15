import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  const AuthService._();
  static const AuthService instance = AuthService._();

  Future<void> signInAnon() async {
    try {
      final result = await _auth.signInAnonymously();
      final user = result.user as User;
      print(user.uid);
    } catch (e) {
      print(e.toString());
    }
  }

  bool isAuth() => _auth.currentUser == null ? false : true;
}
