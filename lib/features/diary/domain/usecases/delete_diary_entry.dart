import '../repositories/diary_repository.dart';

class DeleteDiaryEntryUseCase {
  final DiaryRepository repository;

  DeleteDiaryEntryUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteEntry(id);
  }
}
