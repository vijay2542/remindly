import '../entities/diary_entry.dart';
import '../repositories/diary_repository.dart';

class GetDiaryEntriesUseCase {
  final DiaryRepository repository;

  GetDiaryEntriesUseCase(this.repository);

  Future<List<DiaryEntry>> call() {
    return repository.getAllEntries();
  }

  Stream<List<DiaryEntry>> watch() {
    return repository.watchEntries();
  }

  Future<List<DiaryEntry>> forDate(DateTime date) {
    return repository.getEntriesForDate(date);
  }
}
