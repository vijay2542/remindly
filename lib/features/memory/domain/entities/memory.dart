import 'category.dart';
import 'memory_source_type.dart';

class Memory {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Category category;
  final List<String> tags;
  final MemorySourceType sourceType;
  final DateTime? reminderDate;
  final String? location;
  final Map<String, dynamic>? metadata;
  final bool isSecure;

  const Memory({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.category = Category.other,
    this.tags = const [],
    this.sourceType = MemorySourceType.text,
    this.reminderDate,
    this.location,
    this.metadata,
    this.isSecure = false,
  });

  Memory copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    Category? category,
    List<String>? tags,
    MemorySourceType? sourceType,
    DateTime? reminderDate,
    String? location,
    Map<String, dynamic>? metadata,
    bool? isSecure,
  }) {
    return Memory(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      sourceType: sourceType ?? this.sourceType,
      reminderDate: reminderDate ?? this.reminderDate,
      location: location ?? this.location,
      metadata: metadata ?? this.metadata,
      isSecure: isSecure ?? this.isSecure,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Memory &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          content == other.content &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          category == other.category &&
          sourceType == other.sourceType &&
          reminderDate == other.reminderDate &&
          location == other.location;

  @override
  int get hashCode =>
      id.hashCode ^
      content.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      category.hashCode ^
      sourceType.hashCode ^
      reminderDate.hashCode ^
      location.hashCode;
}
