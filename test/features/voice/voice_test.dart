import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:remindly/core/services/speech_service.dart';
import 'package:remindly/features/voice/data/repositories/voice_repository_impl.dart';
import 'package:remindly/features/voice/domain/entities/voice_state.dart';
import 'package:remindly/features/voice/presentation/providers/voice_providers.dart';

class MockSpeechService extends Mock implements SpeechService {}

void main() {
  late MockSpeechService mockSpeechService;
  late VoiceRepositoryImpl voiceRepository;
  late VoiceStateNotifier notifier;

  setUp(() {
    mockSpeechService = MockSpeechService();
    voiceRepository = VoiceRepositoryImpl(speechService: mockSpeechService);
    notifier = VoiceStateNotifier(voiceRepository);
  });

  group('Voice Input Integration Tests', () {
    test('startListening sets permissionDenied state if speech service fails initialization', () async {
      when(() => mockSpeechService.initialize()).thenAnswer((_) async => false);

      await notifier.startListening();
      await pumpEventQueue();

      expect(notifier.state.status, equals(VoiceStatus.permissionDenied));
      expect(notifier.state.errorMessage, contains('Microphone permission'));
    });

    test('startListening streams listening status when permission granted', () async {
      when(() => mockSpeechService.initialize()).thenAnswer((_) async => true);
      when(() => mockSpeechService.listen(
            onResult: any(named: 'onResult'),
            onError: any(named: 'onError'),
            onSoundLevelChange: any(named: 'onSoundLevelChange'),
          )).thenAnswer((invocation) async {
        final onResult = invocation.namedArguments[#onResult] as Function(String, bool);
        onResult('Spare key in blue cupboard', true);
      });

      await notifier.startListening();
      await pumpEventQueue();

      expect(notifier.state.status, equals(VoiceStatus.success));
      expect(notifier.state.transcription, equals('Spare key in blue cupboard'));
    });

    test('reset clears state to idle', () {
      notifier.reset();
      expect(notifier.state.status, equals(VoiceStatus.idle));
      expect(notifier.state.transcription, isEmpty);
    });
  });
}
