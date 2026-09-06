import 'dart:async';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

abstract class SpeechService {
  Future<bool> initialize();
  Future<void> listen({
    required Function(String text, bool isFinal) onResult,
    required Function(String error) onError,
    required Function() onSoundLevelChange,
  });
  Future<void> stop();
  Future<void> cancel();
  bool get isListening;
}

class SpeechServiceImpl implements SpeechService {
  final SpeechToText _speechToText;

  SpeechServiceImpl([SpeechToText? stt]) : _speechToText = stt ?? SpeechToText();

  @override
  bool get isListening => _speechToText.isListening;

  @override
  Future<bool> initialize() async {
    try {
      return await _speechToText.initialize(
        onError: (SpeechRecognitionError error) {},
        onStatus: (String status) {},
      );
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> listen({
    required Function(String text, bool isFinal) onResult,
    required Function(String error) onError,
    required Function() onSoundLevelChange,
  }) async {
    await _speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        cancelOnError: true,
        partialResults: true,
      ),
    );
  }

  @override
  Future<void> stop() async {
    await _speechToText.stop();
  }

  @override
  Future<void> cancel() async {
    await _speechToText.cancel();
  }
}
