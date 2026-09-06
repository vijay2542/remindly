import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/security/diary_auth_service.dart';
import '../../../../core/security/secure_storage_service.dart';
import '../../../../core/services/biometric_auth_service.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageServiceImpl();
});

final diaryAuthServiceProvider = Provider<DiaryAuthService>((ref) {
  final storage = ref.watch(secureStorageServiceProvider);
  final biometric = BiometricAuthServiceImpl();
  return DiaryAuthServiceImpl(
    storageService: storage,
    biometricService: biometric,
  );
});

class DiaryAuthState {
  final bool hasPin;
  final bool isLocked;
  final bool isLoading;
  final String? error;

  const DiaryAuthState({
    this.hasPin = false,
    this.isLocked = true,
    this.isLoading = true,
    this.error,
  });

  DiaryAuthState copyWith({
    bool? hasPin,
    bool? isLocked,
    bool? isLoading,
    String? error,
  }) {
    return DiaryAuthState(
      hasPin: hasPin ?? this.hasPin,
      isLocked: isLocked ?? this.isLocked,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DiaryAuthNotifier extends StateNotifier<DiaryAuthState> {
  final DiaryAuthService authService;

  DiaryAuthNotifier(this.authService) : super(const DiaryAuthState()) {
    checkInitialState();
  }

  Future<void> checkInitialState() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final hasPin = await authService.isPinCreated();
      state = state.copyWith(
        hasPin: hasPin,
        isLocked: hasPin, // If PIN exists, start locked
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to verify PIN status.');
    }
  }

  Future<bool> createPin(String pin) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await authService.createPin(pin);
      state = state.copyWith(
        hasPin: true,
        isLocked: false,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to save PIN.');
      return false;
    }
  }

  Future<bool> unlockWithPin(String pin) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final isValid = await authService.verifyPin(pin);
      if (isValid) {
        state = state.copyWith(isLocked: false, isLoading: false);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Incorrect PIN. Please try again.');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Unlock failed.');
      return false;
    }
  }

  Future<bool> unlockWithBiometrics() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await authService.authenticateWithBiometrics();
      if (success) {
        state = state.copyWith(isLocked: false, isLoading: false);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Biometric authentication failed.');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Biometric unlock failed.');
      return false;
    }
  }

  void lock() {
    if (state.hasPin) {
      state = state.copyWith(isLocked: true);
    }
  }

  Future<void> resetAuth() async {
    await authService.resetPin();
    state = const DiaryAuthState(hasPin: false, isLocked: false, isLoading: false);
  }
}

final diaryAuthNotifierProvider =
    StateNotifierProvider<DiaryAuthNotifier, DiaryAuthState>((ref) {
  final authService = ref.watch(diaryAuthServiceProvider);
  return DiaryAuthNotifier(authService);
});
