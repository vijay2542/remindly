import '../entities/ai_answer.dart';
import '../repositories/search_repository.dart';

class AskMemoryQuestionUseCase {
  final SearchRepository repository;

  AskMemoryQuestionUseCase(this.repository);

  Future<AiAnswer> call(String question) async {
    if (question.trim().isEmpty) {
      return AiAnswer.notFound(question);
    }
    return await repository.askQuestion(question);
  }
}
