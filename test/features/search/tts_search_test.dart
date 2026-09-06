import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly/core/services/tts_service.dart';
import 'package:remindly/features/search/presentation/pages/search_page.dart';
import 'package:remindly/features/search/presentation/providers/search_providers.dart';

class FakeTtsService implements TtsService {
  String? lastSpokenText;
  bool isStopped = false;

  @override
  Future<void> speak(String text) async {
    lastSpokenText = text;
  }

  @override
  Future<void> stop() async {
    isStopped = true;
  }

  @override
  Future<void> setLanguage(String language) async {}
}

void main() {
  testWidgets('SearchPage renders TTS voice readout toggle icon button', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ttsServiceProvider.overrideWithValue(FakeTtsService()),
        ],
        child: const MaterialApp(
          home: SearchPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.volume_up), findsOneWidget);
  });

  testWidgets('Toggling TTS button updates voice readout setting', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ttsServiceProvider.overrideWithValue(FakeTtsService()),
        ],
        child: const MaterialApp(
          home: SearchPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final volumeButton = find.byIcon(Icons.volume_up);
    expect(volumeButton, findsOneWidget);

    await tester.tap(volumeButton);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.volume_off_outlined), findsOneWidget);
  });
}
