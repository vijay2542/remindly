import '../../../memory/domain/entities/memory.dart';
import '../repositories/search_repository.dart';

class SearchMemoriesUseCase {
  final SearchRepository repository;

  SearchMemoriesUseCase(this.repository);

  Future<List<Memory>> call(String query) async {
    if (query.trim().isEmpty) return const [];
    return await repository.searchMemories(query);
  }
}
