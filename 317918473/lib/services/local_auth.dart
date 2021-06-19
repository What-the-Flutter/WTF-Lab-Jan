import 'package:local_auth/local_auth.dart';

class LocalAuth {
  final _auth = LocalAuthentication();

  Future<bool> get isDeviceSupported async => await _auth.isDeviceSupported();

  Future<bool> get checkBiometrics async => await _auth.canCheckBiometrics;

  Future<List<BiometricType>> get availableBiometrics async =>
      await _auth.getAvailableBiometrics();

  Future<bool>  authenticated() async => await _auth.authenticate(
      localizedReason: 'Let OS determine authentication method');

  Future<bool>  authenticateWithBiometrics() async => await _auth.authenticate(
      localizedReason:
          'Scan your fingerprint (or face or whatever) to authenticate',
      biometricOnly: true);

  Future<void> cancelAuth() async => await _auth.stopAuthentication();
}
