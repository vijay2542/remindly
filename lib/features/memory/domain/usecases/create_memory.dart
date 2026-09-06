import '../entities/memory.dart';
import '../repositories/memory_repository.dart';

class CreateMemoryUseCase {
  final MemoryRepository repository;

  CreateMemoryUseCase(this.repository);

  Future<Memory> call(Memory memory) async {
    if (memory.content.trim().isEmpty) {
      throw ArgumentError('Memory content cannot be empty');
    }
    return await repository.saveMemory(memory);
  }
}
