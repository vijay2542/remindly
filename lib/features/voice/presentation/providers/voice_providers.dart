import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/speech_service.dart';
import '../../data/repositories/voice_repository_impl.dart';
import '../../domain/entities/voice_state.dart';
import '../../domain/repositories/voice_repository.dart';

final speechServiceProvider = Provider<SpeechService>((ref) {
  return SpeechServiceImpl();
});

final voiceRepositoryProvider = Provider<VoiceRepository>((ref) {
  final speechService = ref.watch(speechServiceProvider);
  return VoiceRepositoryImpl(speechService: speechService);
});

class VoiceStateNotifier extends StateNotifier<VoiceState> {
  final VoiceRepository voiceRepository;
  StreamSubscription<VoiceState>? _subscription;

  VoiceStateNotifier(this.voiceRepository) : super(const VoiceState());

  Future<void> startListening({String? localeId}) async {
    final hasPermission = await voiceRepository.initializeAndCheckPermissions();
    if (!hasPermission) {
      state = const VoiceState(
        status: VoiceStatus.permissionDenied,
        errorMessage: 'Microphone permission was denied.',
      );
      return;
    }

    _subscription?.cancel();
    _subscription = voiceRepository.startListening(localeId: localeId).listen((voiceState) {
      state = voiceState;
    });
  }

  Future<void> stopListening() async {
    await voiceRepository.stopListening();
    _subscription?.cancel();
    if (state.transcription.isNotEmpty && state.status == VoiceStatus.listening) {
      state = state.copyWith(status: VoiceStatus.success);
    }
  }

  void reset() {
    _subscription?.cancel();
    state = const VoiceState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final voiceStateNotifierProvider =
    StateNotifierProvider.autoDispose<VoiceStateNotifier, VoiceState>((ref) {
  final repository = ref.watch(voiceRepositoryProvider);
  return VoiceStateNotifier(repository);
});
