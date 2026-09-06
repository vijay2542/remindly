import '../../../memory/domain/entities/memory.dart';

class AiAnswer {
  final String question;
  final String answerText;
  final List<Memory> sourceMemories;
  final bool isFound;
  final double confidenceScore;

  const AiAnswer({
    required this.question,
    required this.answerText,
    required this.sourceMemories,
    required this.isFound,
    this.confidenceScore = 0.0,
  });

  factory AiAnswer.notFound(String question) {
    return AiAnswer(
      question: question,
      answerText: "I couldn't find a reliable memory for that.",
      sourceMemories: const [],
      isFound: false,
      confidenceScore: 0.0,
    );
  }
}
