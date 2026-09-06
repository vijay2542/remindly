import 'package:flutter_tts/flutter_tts.dart';

abstract class TtsService {
  Future<void> speak(String text);
  Future<void> stop();
  Future<void> setLanguage(String language);
}

class FlutterTtsServiceImpl implements TtsService {
  final FlutterTts _flutterTts;

  FlutterTtsServiceImpl([FlutterTts? flutterTts])
      : _flutterTts = flutterTts ?? FlutterTts();

  @override
  Future<void> speak(String text) async {
    try {
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.speak(text);
    } catch (_) {}
  }

  @override
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (_) {}
  }

  @override
  Future<void> setLanguage(String language) async {
    try {
      await _flutterTts.setLanguage(language);
    } catch (_) {}
  }
}
