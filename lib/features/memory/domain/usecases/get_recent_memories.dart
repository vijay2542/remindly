import '../entities/memory.dart';
import '../repositories/memory_repository.dart';

class GetRecentMemoriesUseCase {
  final MemoryRepository repository;

  GetRecentMemoriesUseCase(this.repository);

  Future<List<Memory>> call({int limit = 10}) async {
    return await repository.getRecentMemories(limit: limit);
  }
}
