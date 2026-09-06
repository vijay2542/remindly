import '../entities/voice_state.dart';

abstract class VoiceRepository {
  Future<bool> initializeAndCheckPermissions();
  Stream<VoiceState> startListening({String? localeId});
  Future<void> stopListening();
  Future<void> cancelListening();
}
