import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricHelper {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> canAuth() async {
    final bool canCheckBiometrics = await auth.canCheckBiometrics;
    final bool isDeviceSupported = await auth.isDeviceSupported();
    return canCheckBiometrics && isDeviceSupported; 
  }

  Future<bool> authenticate(String message) async {
    try {
      return await auth.authenticate(
        localizedReason: message,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        )
      );
    } on PlatformException {
      return false;
    }
  }
}