import '../entities/diary_entry.dart';
import '../repositories/diary_repository.dart';

class UpdateDiaryEntryUseCase {
  final DiaryRepository repository;

  UpdateDiaryEntryUseCase(this.repository);

  Future<DiaryEntry> call(DiaryEntry entry) {
    return repository.updateEntry(entry);
  }
}
