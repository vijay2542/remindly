enum VoiceStatus {
  idle,
  listening,
  processing,
  success,
  permissionDenied,
  error,
}

class VoiceState {
  final VoiceStatus status;
  final String transcription;
  final String? errorMessage;

  const VoiceState({
    this.status = VoiceStatus.idle,
    this.transcription = '',
    this.errorMessage,
  });

  VoiceState copyWith({
    VoiceStatus? status,
    String? transcription,
    String? errorMessage,
  }) {
    return VoiceState(
      status: status ?? this.status,
      transcription: transcription ?? this.transcription,
      errorMessage: errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoiceState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          transcription == other.transcription &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => status.hashCode ^ transcription.hashCode ^ errorMessage.hashCode;
}
