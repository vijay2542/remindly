import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:remindly/core/security/diary_auth_service.dart';
import 'package:remindly/core/security/secure_storage_service.dart';
import 'package:remindly/core/services/biometric_auth_service.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}
class MockBiometricAuthService extends Mock implements BiometricAuthService {}

void main() {
  late MockSecureStorageService mockStorage;
  late MockBiometricAuthService mockBiometric;
  late DiaryAuthServiceImpl authService;

  setUp(() {
    mockStorage = MockSecureStorageService();
    mockBiometric = MockBiometricAuthService();
    authService = DiaryAuthServiceImpl(
      storageService: mockStorage,
      biometricService: mockBiometric,
    );
  });

  group('Diary Security & Auth Tests', () {
    test('isPinCreated returns true when PIN hash exists', () async {
      when(() => mockStorage.hasDiaryPin()).thenAnswer((_) async => true);

      final result = await authService.isPinCreated();
      expect(result, isTrue);
    });

    test('createPin saves hashed PIN to storage', () async {
      when(() => mockStorage.saveDiaryPinHash('1234')).thenAnswer((_) async {});

      await authService.createPin('1234');
      verify(() => mockStorage.saveDiaryPinHash('1234')).called(1);
    });

    test('verifyPin accepts correct PIN and rejects incorrect PIN', () async {
      when(() => mockStorage.verifyDiaryPin('1234')).thenAnswer((_) async => true);
      when(() => mockStorage.verifyDiaryPin('9999')).thenAnswer((_) async => false);

      expect(await authService.verifyPin('1234'), isTrue);
      expect(await authService.verifyPin('9999'), isFalse);
    });

    test('resetPin clears stored security PIN', () async {
      when(() => mockStorage.resetDiaryPin()).thenAnswer((_) async {});

      await authService.resetPin();
      verify(() => mockStorage.resetDiaryPin()).called(1);
    });
  });
}
