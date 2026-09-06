import 'package:drift/drift.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../database/app_database.dart';
import '../models/memory_dto.dart';

abstract class MemoryLocalDatasource {
  Future<MemoryDto?> getMemoryById(String id);
  Future<List<MemoryDto>> getAllMemories();
  Future<List<MemoryDto>> getRecentMemories({int limit = 10});
  Future<MemoryDto> insertMemory(MemoryDto dto);
  Future<MemoryDto> updateMemory(MemoryDto dto);
  Future<void> deleteMemory(String id);
  Stream<List<MemoryDto>> watchMemories();
}

class MemoryLocalDatasourceImpl implements MemoryLocalDatasource {
  final AppDatabase db;

  MemoryLocalDatasourceImpl(this.db);

  @override
  Future<MemoryDto?> getMemoryById(String id) async {
    try {
      final query = db.select(db.memories)..where((tbl) => tbl.id.equals(id));
      final entry = await query.getSingleOrNull();
      return entry != null ? MemoryDto.fromEntry(entry) : null;
    } catch (e) {
      throw DatabaseException('Failed to fetch memory by ID', e);
    }
  }

  @override
  Future<List<MemoryDto>> getAllMemories() async {
    try {
      final query = db.select(db.memories)
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)]);
      final entries = await query.get();
      return entries.map((e) => MemoryDto.fromEntry(e)).toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch memories', e);
    }
  }

  @override
  Future<List<MemoryDto>> getRecentMemories({int limit = 10}) async {
    try {
      final query = db.select(db.memories)
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)])
        ..limit(limit);
      final entries = await query.get();
      return entries.map((e) => MemoryDto.fromEntry(e)).toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch recent memories', e);
    }
  }

  @override
  Future<MemoryDto> insertMemory(MemoryDto dto) async {
    try {
      await db.into(db.memories).insert(
            dto.toCompanion(),
            mode: InsertMode.insertOrReplace,
          );
      final inserted = await getMemoryById(dto.id);
      return inserted ?? dto;
    } catch (e) {
      throw DatabaseException('Failed to insert memory', e);
    }
  }

  @override
  Future<MemoryDto> updateMemory(MemoryDto dto) async {
    try {
      await db.update(db.memories).replace(dto.toCompanion());
      final updated = await getMemoryById(dto.id);
      return updated ?? dto;
    } catch (e) {
      throw DatabaseException('Failed to update memory', e);
    }
  }

  @override
  Future<void> deleteMemory(String id) async {
    try {
      await (db.delete(db.memories)..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      throw DatabaseException('Failed to delete memory', e);
    }
  }

  @override
  Stream<List<MemoryDto>> watchMemories() {
    final query = db.select(db.memories)
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)]);
    return query.watch().map(
          (entries) => entries.map((e) => MemoryDto.fromEntry(e)).toList(),
        );
  }
}
