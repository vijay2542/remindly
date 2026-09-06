import '../entities/memory.dart';

abstract class MemoryRepository {
  Future<Memory?> getMemoryById(String id);
  Future<List<Memory>> getAllMemories();
  Future<List<Memory>> getRecentMemories({int limit = 10});
  Future<Memory> saveMemory(Memory memory);
  Future<Memory> updateMemory(Memory memory);
  Future<void> deleteMemory(String id);
  Stream<List<Memory>> watchMemories();
}
