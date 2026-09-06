import '../../domain/entities/memory.dart';
import '../../domain/repositories/memory_repository.dart';
import '../datasources/memory_local_datasource.dart';
import '../models/memory_dto.dart';

class MemoryRepositoryImpl implements MemoryRepository {
  final MemoryLocalDatasource localDatasource;

  MemoryRepositoryImpl({required this.localDatasource});

  @override
  Future<Memory?> getMemoryById(String id) async {
    final dto = await localDatasource.getMemoryById(id);
    return dto?.toDomain();
  }

  @override
  Future<List<Memory>> getAllMemories() async {
    final dtos = await localDatasource.getAllMemories();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<Memory>> getRecentMemories({int limit = 10}) async {
    final dtos = await localDatasource.getRecentMemories(limit: limit);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Memory> saveMemory(Memory memory) async {
    final dto = MemoryDto.fromDomain(memory);
    final savedDto = await localDatasource.insertMemory(dto);
    return savedDto.toDomain();
  }

  @override
  Future<Memory> updateMemory(Memory memory) async {
    final dto = MemoryDto.fromDomain(memory);
    final updatedDto = await localDatasource.updateMemory(dto);
    return updatedDto.toDomain();
  }

  @override
  Future<void> deleteMemory(String id) async {
    await localDatasource.deleteMemory(id);
  }

  @override
  Stream<List<Memory>> watchMemories() {
    return localDatasource.watchMemories().map(
          (dtos) => dtos.map((dto) => dto.toDomain()).toList(),
        );
  }
}
