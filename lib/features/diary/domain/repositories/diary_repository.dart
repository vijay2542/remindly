import '../entities/diary_entry.dart';

abstract class DiaryRepository {
  Future<DiaryEntry?> getEntryById(String id);
  Future<List<DiaryEntry>> getAllEntries();
  Future<List<DiaryEntry>> getEntriesForDate(DateTime date);
  Future<DiaryEntry> createEntry(DiaryEntry entry);
  Future<DiaryEntry> updateEntry(DiaryEntry entry);
  Future<void> deleteEntry(String id);
  Future<List<DiaryEntry>> searchEntries(String query);
  Stream<List<DiaryEntry>> watchEntries();
}
