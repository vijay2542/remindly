import '../../../memory/domain/entities/memory.dart';
import '../../domain/entities/ai_answer.dart';
import '../../domain/repositories/ai_answer_service.dart';
import '../../domain/repositories/memory_search_engine.dart';
import '../../domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final MemorySearchEngine searchEngine;
  final AiAnswerService aiAnswerService;

  SearchRepositoryImpl({
    required this.searchEngine,
    required this.aiAnswerService,
  });

  @override
  Future<List<Memory>> searchMemories(String query) async {
    final searchResult = await searchEngine.search(query);
    return searchResult.matches;
  }

  @override
  Future<AiAnswer> askQuestion(String query) async {
    final searchResult = await searchEngine.search(query, limit: 5);
    return await aiAnswerService.generateAnswer(
      question: query,
      candidateMemories: searchResult.matches,
    );
  }
}
