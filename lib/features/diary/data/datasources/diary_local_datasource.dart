import 'package:drift/drift.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../database/app_database.dart';
import '../models/diary_entry_dto.dart';

abstract class DiaryLocalDatasource {
  Future<DiaryEntryDto?> getEntryById(String id);
  Future<List<DiaryEntryDto>> getAllEntries();
  Future<List<DiaryEntryDto>> getEntriesForDate(DateTime date);
  Future<DiaryEntryDto> insertEntry(DiaryEntryDto dto);
  Future<DiaryEntryDto> updateEntry(DiaryEntryDto dto);
  Future<void> deleteEntry(String id);
  Future<List<DiaryEntryDto>> searchEntries(String query);
  Stream<List<DiaryEntryDto>> watchEntries();
}

class DiaryLocalDatasourceImpl implements DiaryLocalDatasource {
  final AppDatabase db;

  DiaryLocalDatasourceImpl(this.db);

  @override
  Future<DiaryEntryDto?> getEntryById(String id) async {
    try {
      final query = db.select(db.diaryEntries)..where((tbl) => tbl.id.equals(id));
      final entry = await query.getSingleOrNull();
      return entry != null ? DiaryEntryDto.fromData(entry) : null;
    } catch (e) {
      throw DatabaseException('Failed to fetch diary entry by ID', e);
    }
  }

  @override
  Future<List<DiaryEntryDto>> getAllEntries() async {
    try {
      final query = db.select(db.diaryEntries)
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.diaryDate, mode: OrderingMode.desc)]);
      final entries = await query.get();
      return entries.map((e) => DiaryEntryDto.fromData(e)).toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch diary entries', e);
    }
  }

  @override
  Future<List<DiaryEntryDto>> getEntriesForDate(DateTime date) async {
    try {
      final start = DateTime(date.year, date.month, date.day);
      final end = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final query = db.select(db.diaryEntries)
        ..where((tbl) => tbl.diaryDate.isBetweenValues(start, end))
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)]);
      final entries = await query.get();
      return entries.map((e) => DiaryEntryDto.fromData(e)).toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch entries for date', e);
    }
  }

  @override
  Future<DiaryEntryDto> insertEntry(DiaryEntryDto dto) async {
    try {
      await db.into(db.diaryEntries).insert(
            dto.toCompanion(),
            mode: InsertMode.insertOrReplace,
          );
      final inserted = await getEntryById(dto.id);
      return inserted ?? dto;
    } catch (e) {
      throw DatabaseException('Failed to insert diary entry', e);
    }
  }

  @override
  Future<DiaryEntryDto> updateEntry(DiaryEntryDto dto) async {
    try {
      await db.update(db.diaryEntries).replace(dto.toCompanion());
      final updated = await getEntryById(dto.id);
      return updated ?? dto;
    } catch (e) {
      throw DatabaseException('Failed to update diary entry', e);
    }
  }

  @override
  Future<void> deleteEntry(String id) async {
    try {
      await (db.delete(db.diaryEntries)..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      throw DatabaseException('Failed to delete diary entry', e);
    }
  }

  @override
  Future<List<DiaryEntryDto>> searchEntries(String query) async {
    try {
      final q = '%${query.trim().toLowerCase()}%';
      final results = await (db.select(db.diaryEntries)
            ..where((tbl) => tbl.title.lower().like(q) | tbl.content.lower().like(q))
            ..orderBy([(tbl) => OrderingTerm(expression: tbl.diaryDate, mode: OrderingMode.desc)]))
          .get();
      return results.map((e) => DiaryEntryDto.fromData(e)).toList();
    } catch (e) {
      throw DatabaseException('Failed to search diary entries', e);
    }
  }

  @override
  Stream<List<DiaryEntryDto>> watchEntries() {
    final query = db.select(db.diaryEntries)
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.diaryDate, mode: OrderingMode.desc)]);
    return query.watch().map((entries) => entries.map((e) => DiaryEntryDto.fromData(e)).toList());
  }
}
