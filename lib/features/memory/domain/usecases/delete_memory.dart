import '../repositories/memory_repository.dart';

class DeleteMemoryUseCase {
  final MemoryRepository repository;

  DeleteMemoryUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteMemory(id);
  }
}
