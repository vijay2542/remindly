import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/tts_service.dart';
import '../../../../features/memory/presentation/providers/memory_providers.dart';
import '../../../memory/domain/entities/memory.dart';
import '../../data/datasources/local_ai_answer_service.dart';
import '../../data/datasources/local_memory_search_engine.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/entities/ai_answer.dart';
import '../../domain/repositories/ai_answer_service.dart';
import '../../domain/repositories/memory_search_engine.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/usecases/ask_memory_question.dart';
import '../../domain/usecases/search_memories.dart';

final ttsServiceProvider = Provider<TtsService>((ref) {
  return FlutterTtsServiceImpl();
});

final memorySearchEngineProvider = Provider<MemorySearchEngine>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LocalMemorySearchEngine(db);
});

final aiAnswerServiceProvider = Provider<AiAnswerService>((ref) {
  return LocalAiAnswerService();
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final engine = ref.watch(memorySearchEngineProvider);
  final aiService = ref.watch(aiAnswerServiceProvider);
  return SearchRepositoryImpl(searchEngine: engine, aiAnswerService: aiService);
});

final searchMemoriesUseCaseProvider = Provider<SearchMemoriesUseCase>((ref) {
  final repo = ref.watch(searchRepositoryProvider);
  return SearchMemoriesUseCase(repo);
});

final askMemoryQuestionUseCaseProvider = Provider<AskMemoryQuestionUseCase>((ref) {
  final repo = ref.watch(searchRepositoryProvider);
  return AskMemoryQuestionUseCase(repo);
});

class SearchState {
  final String query;
  final bool isLoading;
  final AiAnswer? answer;
  final List<Memory> matches;
  final String? error;
  final bool isVoiceReadoutEnabled;
  final bool isSpeaking;

  const SearchState({
    this.query = '',
    this.isLoading = false,
    this.answer,
    this.matches = const [],
    this.error,
    this.isVoiceReadoutEnabled = true,
    this.isSpeaking = false,
  });

  SearchState copyWith({
    String? query,
    bool? isLoading,
    AiAnswer? answer,
    List<Memory>? matches,
    String? error,
    bool? isVoiceReadoutEnabled,
    bool? isSpeaking,
  }) {
    return SearchState(
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      answer: answer ?? this.answer,
      matches: matches ?? this.matches,
      error: error,
      isVoiceReadoutEnabled: isVoiceReadoutEnabled ?? this.isVoiceReadoutEnabled,
      isSpeaking: isSpeaking ?? this.isSpeaking,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final SearchMemoriesUseCase searchUseCase;
  final AskMemoryQuestionUseCase askUseCase;
  final TtsService ttsService;

  SearchNotifier({
    required this.searchUseCase,
    required this.askUseCase,
    required this.ttsService,
  }) : super(const SearchState());

  void toggleVoiceReadout() {
    final next = !state.isVoiceReadoutEnabled;
    state = state.copyWith(isVoiceReadoutEnabled: next);
    if (!next) {
      stopSpeaking();
    }
  }

  Future<void> speakAnswerText([String? textToSpeak, String? ttsLanguage]) async {
    final text = textToSpeak ?? state.answer?.answerText;
    if (text != null && text.isNotEmpty) {
      state = state.copyWith(isSpeaking: true);
      await ttsService.speak(text, ttsLanguage);
    }
  }

  Future<void> stopSpeaking() async {
    await ttsService.stop();
    state = state.copyWith(isSpeaking: false);
  }

  Future<void> executeQuery(String query) async {
    final cleaned = query.trim();
    if (cleaned.isEmpty) {
      await stopSpeaking();
      state = state.copyWith(query: '', answer: null, matches: []);
      return;
    }

    state = state.copyWith(query: cleaned, isLoading: true, error: null);

    try {
      final answerFuture = askUseCase(cleaned);
      final matchesFuture = searchUseCase(cleaned);

      final answer = await answerFuture;
      final matches = await matchesFuture;

      state = state.copyWith(
        query: cleaned,
        isLoading: false,
        answer: answer,
        matches: matches,
      );

      if (state.isVoiceReadoutEnabled && answer.answerText.isNotEmpty) {
        speakAnswerText(answer.answerText);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to process query.');
    }
  }
}

final searchNotifierProvider =
    StateNotifierProvider.autoDispose<SearchNotifier, SearchState>((ref) {
  final searchUseCase = ref.watch(searchMemoriesUseCaseProvider);
  final askUseCase = ref.watch(askMemoryQuestionUseCaseProvider);
  final ttsService = ref.watch(ttsServiceProvider);
  return SearchNotifier(
    searchUseCase: searchUseCase,
    askUseCase: askUseCase,
    ttsService: ttsService,
  );
});
