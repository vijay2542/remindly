import '../services/biometric_auth_service.dart';
import 'secure_storage_service.dart';

abstract class DiaryAuthService {
  Future<bool> isPinCreated();
  Future<void> createPin(String pin);
  Future<bool> verifyPin(String pin);
  Future<bool> authenticateWithBiometrics();
  Future<void> resetPin();
  Future<int> getLockTimeout();
  Future<void> setLockTimeout(int minutes);
}

class DiaryAuthServiceImpl implements DiaryAuthService {
  final SecureStorageService storageService;
  final BiometricAuthService biometricService;

  DiaryAuthServiceImpl({
    required this.storageService,
    required this.biometricService,
  });

  @override
  Future<bool> isPinCreated() async {
    return await storageService.hasDiaryPin();
  }

  @override
  Future<void> createPin(String pin) async {
    await storageService.saveDiaryPinHash(pin);
  }

  @override
  Future<bool> verifyPin(String pin) async {
    return await storageService.verifyDiaryPin(pin);
  }

  @override
  Future<bool> authenticateWithBiometrics() async {
    final available = await biometricService.isBiometricAvailable();
    if (!available) return false;
    return await biometricService.authenticate(
      reason: 'Unlock private diary entries',
    );
  }

  @override
  Future<void> resetPin() async {
    await storageService.resetDiaryPin();
  }

  @override
  Future<int> getLockTimeout() async {
    return await storageService.getLockTimeoutMinutes();
  }

  @override
  Future<void> setLockTimeout(int minutes) async {
    await storageService.setLockTimeoutMinutes(minutes);
  }
}
