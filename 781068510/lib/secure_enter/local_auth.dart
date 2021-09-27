import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> authenticate() async{
    final isAvailable = await hasBiometric();
    if (!isAvailable) return false;

    try {
      return await _auth.authenticate(
        biometricOnly: true,
        localizedReason: 'Please authenticate with your fingerprint to proceed',
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> hasBiometric() async{
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }
}