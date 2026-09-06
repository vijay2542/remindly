import 'package:drift/drift.dart';
import '../../../../database/app_database.dart';
import '../../domain/entities/diary_entry.dart';

class DiaryEntryDto {
  final String id;
  final String title;
  final String content;
  final DateTime diaryDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DiaryEntryDto({
    required this.id,
    required this.title,
    required this.content,
    required this.diaryDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DiaryEntryDto.fromDomain(DiaryEntry domain) {
    return DiaryEntryDto(
      id: domain.id,
      title: domain.title,
      content: domain.content,
      diaryDate: domain.diaryDate,
      createdAt: domain.createdAt,
      updatedAt: domain.updatedAt,
    );
  }

  factory DiaryEntryDto.fromData(DiaryEntryData entry) {
    return DiaryEntryDto(
      id: entry.id,
      title: entry.title,
      content: entry.content,
      diaryDate: entry.diaryDate,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }

  DiaryEntry toDomain() {
    return DiaryEntry(
      id: id,
      title: title,
      content: content,
      diaryDate: diaryDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  DiaryEntriesCompanion toCompanion() {
    return DiaryEntriesCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      diaryDate: Value(diaryDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
}
