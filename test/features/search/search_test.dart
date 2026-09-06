import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly/database/app_database.dart';
import 'package:remindly/features/memory/data/datasources/memory_local_datasource.dart';
import 'package:remindly/features/memory/data/models/memory_dto.dart';
import 'package:remindly/features/memory/domain/entities/category.dart';
import 'package:remindly/features/memory/domain/entities/memory.dart';
import 'package:remindly/features/search/data/datasources/local_ai_answer_service.dart';
import 'package:remindly/features/search/data/datasources/local_memory_search_engine.dart';

void main() {
  late AppDatabase db;
  late LocalMemorySearchEngine searchEngine;
  late LocalAiAnswerService aiAnswerService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    searchEngine = LocalMemorySearchEngine(db);
    aiAnswerService = LocalAiAnswerService();
  });

  tearDown(() async {
    await db.close();
  });

  group('Local AI Search Engine & Non-Hallucination QA Tests', () {
    final keyMemory = Memory(
      id: 'mem-1',
      content: 'Remember that the spare key is inside the blue cupboard.',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      category: Category.home,
      tags: const ['home', 'keys'],
    );

    final washingMemory = Memory(
      id: 'mem-2',
      content: 'Washing machine serviced on August 20.',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      category: Category.home,
    );

    test('LocalMemorySearchEngine returns correct matching memory', () async {
      final repo = MemoryLocalDatasourceImpl(db);
      await repo.insertMemory(MemoryDto.fromDomain(keyMemory));
      await repo.insertMemory(MemoryDto.fromDomain(washingMemory));

      final result = await searchEngine.search('spare key');
      expect(result.matches.length, equals(1));
      expect(result.matches.first.id, equals('mem-1'));
    });

    test('LocalAiAnswerService synthesizes answer from stored memory', () async {
      final answer = await aiAnswerService.generateAnswer(
        question: 'Where is the spare key?',
        candidateMemories: [keyMemory],
      );

      expect(answer.isFound, isTrue);
      expect(answer.answerText, equals('The spare key is inside the blue cupboard.'));
      expect(answer.sourceMemories.first.content, equals(keyMemory.content));
    });

    test('LocalAiAnswerService returns fallback when no match is found (zero hallucination)', () async {
      final answer = await aiAnswerService.generateAnswer(
        question: 'Where did I keep the passport?',
        candidateMemories: [washingMemory],
      );

      expect(answer.isFound, isFalse);
      expect(answer.answerText, equals("I couldn't find a reliable memory for that."));
      expect(answer.sourceMemories, isEmpty);
    });
  });
}
