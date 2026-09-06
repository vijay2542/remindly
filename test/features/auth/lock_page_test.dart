import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:remindly/core/services/biometric_auth_service.dart';
import 'package:remindly/features/auth/presentation/pages/lock_page.dart';
import 'package:remindly/features/auth/presentation/providers/auth_provider.dart';

class FakeBiometricAuthService implements BiometricAuthService {
  @override
  Future<bool> authenticate({required String reason, bool allowDeviceCredentials = true}) async => false;

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async => [];

  @override
  Future<bool> isBiometricAvailable() async => false;
}

void main() {
  testWidgets('LockPage renders app lock title, fingerprint button, and PIN keypad', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          biometricAuthServiceProvider.overrideWithValue(FakeBiometricAuthService()),
        ],
        child: const MaterialApp(
          home: LockPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Remindly Locked'), findsOneWidget);
    expect(find.text('Fingerprint / Mobile Password'), findsOneWidget);
    expect(find.text('OR ENTER PASSCODE'), findsOneWidget);
    expect(find.text('Default PIN: 1234'), findsOneWidget);
  });

  testWidgets('LockPage allows tapping PIN keys', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          biometricAuthServiceProvider.overrideWithValue(FakeBiometricAuthService()),
        ],
        child: const MaterialApp(
          home: LockPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap 1, 2, 3, 4
    await tester.tap(find.text('1'));
    await tester.pump();
    await tester.tap(find.text('2'));
    await tester.pump();
    await tester.tap(find.text('3'));
    await tester.pump();
    await tester.tap(find.text('4'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(LockPage), findsOneWidget);
  });
}
