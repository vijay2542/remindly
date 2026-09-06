import '../../../memory/domain/entities/memory.dart';
import '../entities/ai_answer.dart';

abstract class SearchRepository {
  Future<List<Memory>> searchMemories(String query);
  Future<AiAnswer> askQuestion(String query);
}
