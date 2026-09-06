import '../../domain/entities/diary_entry.dart';
import '../../domain/repositories/diary_repository.dart';
import '../datasources/diary_local_datasource.dart';
import '../models/diary_entry_dto.dart';

class DiaryRepositoryImpl implements DiaryRepository {
  final DiaryLocalDatasource localDatasource;

  DiaryRepositoryImpl({required this.localDatasource});

  @override
  Future<DiaryEntry?> getEntryById(String id) async {
    final dto = await localDatasource.getEntryById(id);
    return dto?.toDomain();
  }

  @override
  Future<List<DiaryEntry>> getAllEntries() async {
    final dtos = await localDatasource.getAllEntries();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<DiaryEntry>> getEntriesForDate(DateTime date) async {
    final dtos = await localDatasource.getEntriesForDate(date);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<DiaryEntry> createEntry(DiaryEntry entry) async {
    final dto = DiaryEntryDto.fromDomain(entry);
    final savedDto = await localDatasource.insertEntry(dto);
    return savedDto.toDomain();
  }

  @override
  Future<DiaryEntry> updateEntry(DiaryEntry entry) async {
    final dto = DiaryEntryDto.fromDomain(entry);
    final updatedDto = await localDatasource.updateEntry(dto);
    return updatedDto.toDomain();
  }

  @override
  Future<void> deleteEntry(String id) async {
    await localDatasource.deleteEntry(id);
  }

  @override
  Future<List<DiaryEntry>> searchEntries(String query) async {
    final dtos = await localDatasource.searchEntries(query);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Stream<List<DiaryEntry>> watchEntries() {
    return localDatasource.watchEntries().map(
          (dtos) => dtos.map((dto) => dto.toDomain()).toList(),
        );
  }
}
