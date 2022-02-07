import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      return await _auth.authenticate(
        androidAuthStrings: const AndroidAuthMessages(
          signInTitle: 'Face ID Required',
        ),
        localizedReason: 'Scan Face to Authenticate',
        biometricOnly: true,
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
      // final isDeviceSupported = await _auth.isDeviceSupported();
      // return isAvailable && isDeviceSupported;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
