import '../../../memory/domain/entities/memory.dart';
import '../../domain/entities/ai_answer.dart';
import '../../domain/repositories/ai_answer_service.dart';

class LocalAiAnswerService implements AiAnswerService {
  @override
  Future<AiAnswer> generateAnswer({
    required String question,
    required List<Memory> candidateMemories,
  }) async {
    final cleanedQuestion = question.trim().toLowerCase();

    if (candidateMemories.isEmpty || cleanedQuestion.isEmpty) {
      return AiAnswer.notFound(question);
    }

    // Question token matching & entity extraction
    Memory? bestMatch;
    int highestTokenMatchCount = 0;

    final questionTokens = _tokenize(cleanedQuestion);

    for (final memory in candidateMemories) {
      final memoryTokens = _tokenize(memory.content.toLowerCase());

      int matchesCount = 0;
      for (final qToken in questionTokens) {
        if (memoryTokens.contains(qToken)) {
          matchesCount++;
        }
      }

      if (matchesCount > highestTokenMatchCount) {
        highestTokenMatchCount = matchesCount;
        bestMatch = memory;
      }
    }

    // Require at least 1 meaningful token match or non-empty candidate list with strong relevance
    if (bestMatch == null || highestTokenMatchCount == 0) {
      // Check if candidate list contains direct phrase match
      for (final memory in candidateMemories) {
        if (_hasKeywordOverlap(cleanedQuestion, memory.content.toLowerCase())) {
          bestMatch = memory;
          break;
        }
      }
    }

    if (bestMatch == null) {
      return AiAnswer.notFound(question);
    }

    final answerPhrase = _synthesizeAnswerFromMemory(cleanedQuestion, bestMatch.content);

    return AiAnswer(
      question: question,
      answerText: answerPhrase,
      sourceMemories: [bestMatch],
      isFound: true,
      confidenceScore: 0.95,
    );
  }

  Set<String> _tokenize(String text) {
    final stopWords = {
      'is', 'are', 'was', 'were', 'the', 'a', 'an', 'in', 'on', 'at', 'to',
      'for', 'of', 'with', 'where', 'when', 'what', 'who', 'how', 'did', 'i',
      'my', 'that', 'this', 'it', 'keep', 'put', 'placed', 'remember'
    };

    return text
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(RegExp(r'\s+'))
        .where((t) => t.length > 1 && !stopWords.contains(t))
        .toSet();
  }

  bool _hasKeywordOverlap(String question, String memoryContent) {
    final qTokens = _tokenize(question);
    final mTokens = _tokenize(memoryContent);
    return qTokens.intersection(mTokens).isNotEmpty;
  }

  String _synthesizeAnswerFromMemory(String question, String memoryContent) {
    // Standard rule-based answer transformation (e.g. "Remember that the spare key is inside the blue cupboard." -> "The spare key is inside the blue cupboard.")
    String text = memoryContent.trim();
    if (text.toLowerCase().startsWith('remember that ')) {
      text = text.substring(14);
      if (text.isNotEmpty) {
        text = text[0].toUpperCase() + text.substring(1);
      }
    } else if (text.toLowerCase().startsWith('remember ')) {
      text = text.substring(9);
      if (text.isNotEmpty) {
        text = text[0].toUpperCase() + text.substring(1);
      }
    }
    return text;
  }
}
