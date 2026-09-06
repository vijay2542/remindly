import '../../../memory/domain/entities/memory.dart';
import '../entities/ai_answer.dart';

abstract class AiAnswerService {
  Future<AiAnswer> generateAnswer({
    required String question,
    required List<Memory> candidateMemories,
  });
}
