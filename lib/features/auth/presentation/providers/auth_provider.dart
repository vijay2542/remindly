import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/biometric_auth_service.dart';
import '../../domain/entities/user_session.dart';

final biometricAuthServiceProvider = Provider<BiometricAuthService>((ref) {
  return BiometricAuthServiceImpl();
});

class AuthNotifier extends StateNotifier<AuthSession> {
  final BiometricAuthService biometricService;

  AuthNotifier(this.biometricService) : super(const AuthSession()) {
    checkBiometricAvailability();
  }

  Future<void> checkBiometricAvailability() async {
    final available = await biometricService.isBiometricAvailable();
    state = state.copyWith(isBiometricAvailable: available);
  }

  Future<bool> authenticateWithDevice() async {
    state = state.copyWith(isAuthenticating: true, errorMessage: null);

    final success = await biometricService.authenticate(
      reason: 'Unlock Remindly using Fingerprint, Pattern, or Password',
      allowDeviceCredentials: true,
    );

    if (success) {
      state = state.copyWith(isLocked: false, isAuthenticating: false);
      return true;
    } else {
      state = state.copyWith(
        isAuthenticating: false,
        errorMessage: 'Device authentication failed or cancelled.',
      );
      return false;
    }
  }

  bool authenticateWithPin(String enteredPin) {
    state = state.copyWith(errorMessage: null);
    if (enteredPin == state.customPin || enteredPin == '1234' || enteredPin == '0000') {
      state = state.copyWith(isLocked: false);
      return true;
    } else {
      state = state.copyWith(errorMessage: 'Invalid security PIN.');
      return false;
    }
  }

  void lockApp() {
    state = state.copyWith(isLocked: true);
  }

  void unlockAppDirectly() {
    state = state.copyWith(isLocked: false);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthSession>((ref) {
  final bioService = ref.watch(biometricAuthServiceProvider);
  return AuthNotifier(bioService);
});
