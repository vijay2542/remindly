import '../entities/memory.dart';
import '../repositories/memory_repository.dart';

class GetMemoriesUseCase {
  final MemoryRepository repository;

  GetMemoriesUseCase(this.repository);

  Future<List<Memory>> call() async {
    return await repository.getAllMemories();
  }

  Stream<List<Memory>> watch() {
    return repository.watchMemories();
  }
}
