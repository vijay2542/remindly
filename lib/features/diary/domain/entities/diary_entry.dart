class DiaryEntry {
  final String id;
  final String title;
  final String content;
  final DateTime diaryDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.diaryDate,
    required this.createdAt,
    required this.updatedAt,
  });

  DiaryEntry copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? diaryDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      diaryDate: diaryDate ?? this.diaryDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get snippet {
    final trimmed = content.trim();
    if (trimmed.length <= 100) return trimmed;
    return '${trimmed.substring(0, 97)}...';
  }

  @override
  String toString() {
    // SECURITY: Never print or log sensitive diary content
    return 'DiaryEntry(id: $id, title: $title, diaryDate: $diaryDate)';
  }
}
