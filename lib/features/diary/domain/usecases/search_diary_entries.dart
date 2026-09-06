import '../entities/diary_entry.dart';
import '../repositories/diary_repository.dart';

class SearchDiaryEntriesUseCase {
  final DiaryRepository repository;

  SearchDiaryEntriesUseCase(this.repository);

  Future<List<DiaryEntry>> call(String query) {
    return repository.searchEntries(query);
  }
}
