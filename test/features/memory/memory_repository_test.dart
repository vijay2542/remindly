import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly/database/app_database.dart';
import 'package:remindly/features/memory/data/datasources/memory_local_datasource.dart';
import 'package:remindly/features/memory/data/repositories/memory_repository_impl.dart';
import 'package:remindly/features/memory/domain/entities/category.dart';
import 'package:remindly/features/memory/domain/entities/memory.dart';
import 'package:remindly/features/memory/domain/entities/memory_source_type.dart';
import 'package:remindly/features/memory/domain/usecases/create_memory.dart';
import 'package:remindly/features/memory/domain/usecases/delete_memory.dart';
import 'package:remindly/features/memory/domain/usecases/get_memories.dart';
import 'package:remindly/features/memory/domain/usecases/update_memory.dart';

void main() {
  late AppDatabase db;
  late MemoryLocalDatasource localDatasource;
  late MemoryRepositoryImpl repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    localDatasource = MemoryLocalDatasourceImpl(db);
    repository = MemoryRepositoryImpl(localDatasource: localDatasource);
  });

  tearDown(() async {
    await db.close();
  });

  group('MemoryRepository & Database Persistence Tests', () {
    final testMemory = Memory(
      id: 'mem-123',
      content: 'The spare key is inside the blue cupboard.',
      createdAt: DateTime(2026, 8, 20, 10, 0),
      updatedAt: DateTime(2026, 8, 20, 10, 0),
      category: Category.home,
      tags: const ['home', 'keys'],
      sourceType: MemorySourceType.text,
    );

    test('Create and retrieve memory by ID', () async {
      final createUseCase = CreateMemoryUseCase(repository);
      final created = await createUseCase(testMemory);

      expect(created.id, equals('mem-123'));
      expect(created.content, equals('The spare key is inside the blue cupboard.'));
      expect(created.category, equals(Category.home));
      expect(created.tags, contains('keys'));

      final retrieved = await repository.getMemoryById('mem-123');
      expect(retrieved, isNotNull);
      expect(retrieved!.content, equals(testMemory.content));
    });

    test('Update memory content and category', () async {
      await repository.saveMemory(testMemory);

      final updatedMemory = testMemory.copyWith(
        content: 'The spare key is inside the kitchen drawer.',
        category: Category.other,
      );

      final updateUseCase = UpdateMemoryUseCase(repository);
      await updateUseCase(updatedMemory);

      final retrieved = await repository.getMemoryById('mem-123');
      expect(retrieved?.content, equals('The spare key is inside the kitchen drawer.'));
      expect(retrieved?.category, equals(Category.other));
    });

    test('Delete memory by ID', () async {
      await repository.saveMemory(testMemory);

      final deleteUseCase = DeleteMemoryUseCase(repository);
      await deleteUseCase('mem-123');

      final retrieved = await repository.getMemoryById('mem-123');
      expect(retrieved, isNull);
    });

    test('Get recent memories returns items sorted by createdAt DESC', () async {
      final mem1 = testMemory.copyWith(id: '1', createdAt: DateTime(2026, 1, 1));
      final mem2 = testMemory.copyWith(id: '2', createdAt: DateTime(2026, 5, 1));
      final mem3 = testMemory.copyWith(id: '3', createdAt: DateTime(2026, 8, 1));

      await repository.saveMemory(mem1);
      await repository.saveMemory(mem2);
      await repository.saveMemory(mem3);

      final getMemoriesUseCase = GetMemoriesUseCase(repository);
      final list = await getMemoriesUseCase();

      expect(list.length, equals(3));
      expect(list[0].id, equals('3'));
      expect(list[1].id, equals('2'));
      expect(list[2].id, equals('1'));
    });
  });
}
