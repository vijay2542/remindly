import '../entities/memory.dart';
import '../repositories/memory_repository.dart';

class UpdateMemoryUseCase {
  final MemoryRepository repository;

  UpdateMemoryUseCase(this.repository);

  Future<Memory> call(Memory memory) async {
    if (memory.content.trim().isEmpty) {
      throw ArgumentError('Memory content cannot be empty');
    }
    return await repository.updateMemory(memory);
  }
}
