import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  const SearchState({
    this.query = '',
    this.isLoading = false,
    this.answer,
    this.matches = const [],
    this.error,
  });

  SearchState copyWith({
    String? query,
    bool? isLoading,
    AiAnswer? answer,
    List<Memory>? matches,
    String? error,
  }) {
    return SearchState(
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      answer: answer ?? this.answer,
      matches: matches ?? this.matches,
      error: error,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final SearchMemoriesUseCase searchUseCase;
  final AskMemoryQuestionUseCase askUseCase;

  SearchNotifier({
    required this.searchUseCase,
    required this.askUseCase,
  }) : super(const SearchState());

  Future<void> executeQuery(String query) async {
    final cleaned = query.trim();
    if (cleaned.isEmpty) {
      state = const SearchState();
      return;
    }

    state = state.copyWith(query: cleaned, isLoading: true, error: null);

    try {
      final answerFuture = askUseCase(cleaned);
      final matchesFuture = searchUseCase(cleaned);

      final answer = await answerFuture;
      final matches = await matchesFuture;

      state = SearchState(
        query: cleaned,
        isLoading: false,
        answer: answer,
        matches: matches,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to process query.');
    }
  }
}

final searchNotifierProvider =
    StateNotifierProvider.autoDispose<SearchNotifier, SearchState>((ref) {
  final searchUseCase = ref.watch(searchMemoriesUseCaseProvider);
  final askUseCase = ref.watch(askMemoryQuestionUseCaseProvider);
  return SearchNotifier(searchUseCase: searchUseCase, askUseCase: askUseCase);
});
