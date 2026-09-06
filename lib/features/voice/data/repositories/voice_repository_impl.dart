import 'dart:async';
import '../../../../core/services/speech_service.dart';
import '../../domain/entities/voice_state.dart';
import '../../domain/repositories/voice_repository.dart';

class VoiceRepositoryImpl implements VoiceRepository {
  final SpeechService speechService;

  VoiceRepositoryImpl({required this.speechService});

  @override
  Future<bool> initializeAndCheckPermissions() async {
    return await speechService.initialize();
  }

  @override
  Stream<VoiceState> startListening() {
    final controller = StreamController<VoiceState>();

    controller.add(const VoiceState(status: VoiceStatus.listening, transcription: 'Listening...'));

    speechService.listen(
      onResult: (text, isFinal) {
        if (text.isNotEmpty) {
          controller.add(VoiceState(
            status: isFinal ? VoiceStatus.success : VoiceStatus.listening,
            transcription: text,
          ));
        }
      },
      onError: (error) {
        controller.add(VoiceState(
          status: VoiceStatus.error,
          errorMessage: error,
        ));
      },
      onSoundLevelChange: () {},
    );

    return controller.stream;
  }

  @override
  Future<void> stopListening() async {
    await speechService.stop();
  }

  @override
  Future<void> cancelListening() async {
    await speechService.cancel();
  }
}
