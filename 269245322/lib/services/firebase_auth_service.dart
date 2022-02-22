import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in anon
  Future signInAnon() async {
    try {
      final result = await _auth.signInAnonymously();
      final user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
