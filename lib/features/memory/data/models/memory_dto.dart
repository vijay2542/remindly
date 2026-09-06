import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../database/app_database.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/memory.dart';
import '../../domain/entities/memory_source_type.dart';

class MemoryDto {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String category;
  final List<String> tags;
  final String sourceType;
  final DateTime? reminderDate;
  final String? location;
  final Map<String, dynamic>? metadata;
  final bool isSecure;

  MemoryDto({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.tags,
    required this.sourceType,
    this.reminderDate,
    this.location,
    this.metadata,
    this.isSecure = false,
  });

  factory MemoryDto.fromDomain(Memory domain) {
    return MemoryDto(
      id: domain.id,
      content: domain.content,
      createdAt: domain.createdAt,
      updatedAt: domain.updatedAt,
      category: domain.category.name,
      tags: domain.tags,
      sourceType: domain.sourceType.name,
      reminderDate: domain.reminderDate,
      location: domain.location,
      metadata: domain.metadata,
      isSecure: domain.isSecure,
    );
  }

  factory MemoryDto.fromEntry(MemoryEntry entry) {
    List<String> parsedTags = [];
    try {
      final decoded = jsonDecode(entry.tags);
      if (decoded is List) {
        parsedTags = decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {
      parsedTags = [];
    }

    Map<String, dynamic>? parsedMetadata;
    if (entry.metadata != null) {
      try {
        final decoded = jsonDecode(entry.metadata!);
        if (decoded is Map<String, dynamic>) {
          parsedMetadata = decoded;
        }
      } catch (_) {}
    }

    return MemoryDto(
      id: entry.id,
      content: entry.content,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
      category: entry.category,
      tags: parsedTags,
      sourceType: entry.sourceType,
      reminderDate: entry.reminderDate,
      location: entry.location,
      metadata: parsedMetadata,
      isSecure: entry.isSecure,
    );
  }

  Memory toDomain() {
    return Memory(
      id: id,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      category: Category.fromString(category),
      tags: tags,
      sourceType: MemorySourceType.fromString(sourceType),
      reminderDate: reminderDate,
      location: location,
      metadata: metadata,
      isSecure: isSecure,
    );
  }

  MemoriesCompanion toCompanion() {
    return MemoriesCompanion(
      id: Value(id),
      content: Value(content),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      category: Value(category),
      tags: Value(jsonEncode(tags)),
      sourceType: Value(sourceType),
      reminderDate: Value(reminderDate),
      location: Value(location),
      metadata: Value(metadata != null ? jsonEncode(metadata) : null),
      isSecure: Value(isSecure),
    );
  }
}
