import '../entities/diary_entry.dart';
import '../repositories/diary_repository.dart';

class GetDiaryEntryUseCase {
  final DiaryRepository repository;

  GetDiaryEntryUseCase(this.repository);

  Future<DiaryEntry?> call(String id) {
    return repository.getEntryById(id);
  }
}
