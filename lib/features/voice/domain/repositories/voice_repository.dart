import '../entities/voice_state.dart';

abstract class VoiceRepository {
  Future<bool> initializeAndCheckPermissions();
  Stream<VoiceState> startListening();
  Future<void> stopListening();
  Future<void> cancelListening();
}
