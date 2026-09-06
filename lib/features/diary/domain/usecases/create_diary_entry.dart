import '../entities/diary_entry.dart';
import '../repositories/diary_repository.dart';

class CreateDiaryEntryUseCase {
  final DiaryRepository repository;

  CreateDiaryEntryUseCase(this.repository);

  Future<DiaryEntry> call(DiaryEntry entry) {
    return repository.createEntry(entry);
  }
}
