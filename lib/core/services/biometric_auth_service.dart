import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

abstract class BiometricAuthService {
  Future<bool> isBiometricAvailable();
  Future<List<BiometricType>> getAvailableBiometrics();
  Future<bool> authenticate({
    required String reason,
    bool allowDeviceCredentials = true,
  });
}

class BiometricAuthServiceImpl implements BiometricAuthService {
  final LocalAuthentication _localAuth;

  BiometricAuthServiceImpl([LocalAuthentication? localAuth])
      : _localAuth = localAuth ?? LocalAuthentication();

  @override
  Future<bool> isBiometricAvailable() async {
    try {
      final canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return canAuthenticateWithBiometrics || isDeviceSupported;
    } on PlatformException catch (_) {
      return false;
    }
  }

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (_) {
      return [];
    }
  }

  @override
  Future<bool> authenticate({
    required String reason,
    bool allowDeviceCredentials = true,
  }) async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return false;
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: !allowDeviceCredentials,
          useErrorDialogs: true,
        ),
      );
      return authenticated;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable || e.code == auth_error.notEnrolled) {
        return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
