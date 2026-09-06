import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/app_database.dart';
import '../../data/datasources/memory_local_datasource.dart';
import '../../data/repositories/memory_repository_impl.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/memory.dart';
import '../../domain/entities/memory_source_type.dart';
import '../../domain/repositories/memory_repository.dart';
import '../../domain/usecases/create_memory.dart';
import '../../domain/usecases/delete_memory.dart';
import '../../domain/usecases/get_memories.dart';
import '../../domain/usecases/get_recent_memories.dart';
import '../../domain/usecases/update_memory.dart';
import '../../../reminder/domain/entities/reminder.dart';
import '../../../reminder/domain/usecases/schedule_reminder.dart';
import '../../../reminder/presentation/providers/reminder_providers.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final memoryLocalDatasourceProvider = Provider<MemoryLocalDatasource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return MemoryLocalDatasourceImpl(db);
});

final memoryRepositoryProvider = Provider<MemoryRepository>((ref) {
  final datasource = ref.watch(memoryLocalDatasourceProvider);
  return MemoryRepositoryImpl(localDatasource: datasource);
});

final getMemoriesUseCaseProvider = Provider<GetMemoriesUseCase>((ref) {
  final repo = ref.watch(memoryRepositoryProvider);
  return GetMemoriesUseCase(repo);
});

final getRecentMemoriesUseCaseProvider = Provider<GetRecentMemoriesUseCase>((ref) {
  final repo = ref.watch(memoryRepositoryProvider);
  return GetRecentMemoriesUseCase(repo);
});

final createMemoryUseCaseProvider = Provider<CreateMemoryUseCase>((ref) {
  final repo = ref.watch(memoryRepositoryProvider);
  return CreateMemoryUseCase(repo);
});

final updateMemoryUseCaseProvider = Provider<UpdateMemoryUseCase>((ref) {
  final repo = ref.watch(memoryRepositoryProvider);
  return UpdateMemoryUseCase(repo);
});

final deleteMemoryUseCaseProvider = Provider<DeleteMemoryUseCase>((ref) {
  final repo = ref.watch(memoryRepositoryProvider);
  return DeleteMemoryUseCase(repo);
});

final recentMemoriesProvider = StreamProvider<List<Memory>>((ref) {
  final repo = ref.watch(memoryRepositoryProvider);
  return repo.watchMemories();
});

class AddMemoryState {
  final String content;
  final Category category;
  final List<String> tags;
  final MemorySourceType sourceType;
  final DateTime? reminderDate;
  final bool isSaving;
  final String? errorMessage;

  const AddMemoryState({
    this.content = '',
    this.category = Category.other,
    this.tags = const [],
    this.sourceType = MemorySourceType.text,
    this.reminderDate,
    this.isSaving = false,
    this.errorMessage,
  });

  AddMemoryState copyWith({
    String? content,
    Category? category,
    List<String>? tags,
    MemorySourceType? sourceType,
    DateTime? reminderDate,
    bool clearReminder = false,
    bool? isSaving,
    String? errorMessage,
  }) {
    return AddMemoryState(
      content: content ?? this.content,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      sourceType: sourceType ?? this.sourceType,
      reminderDate: clearReminder ? null : (reminderDate ?? this.reminderDate),
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
    );
  }
}

class AddMemoryNotifier extends StateNotifier<AddMemoryState> {
  final CreateMemoryUseCase createMemoryUseCase;
  final ScheduleReminderUseCase? scheduleReminderUseCase;

  AddMemoryNotifier(
    this.createMemoryUseCase, [
    this.scheduleReminderUseCase,
  ]) : super(const AddMemoryState());

  void setContent(String content) {
    state = state.copyWith(content: content, errorMessage: null);
  }

  void setCategory(Category category) {
    state = state.copyWith(category: category);
  }

  void addTag(String tag) {
    final cleaned = tag.trim().replaceAll('#', '');
    if (cleaned.isNotEmpty && !state.tags.contains(cleaned)) {
      state = state.copyWith(tags: [...state.tags, cleaned]);
    }
  }

  void removeTag(String tag) {
    state = state.copyWith(tags: state.tags.where((t) => t != tag).toList());
  }

  void setSourceType(MemorySourceType sourceType) {
    state = state.copyWith(sourceType: sourceType);
  }

  void setReminderDate(DateTime? date) {
    if (date == null) {
      state = state.copyWith(clearReminder: true);
    } else {
      state = state.copyWith(reminderDate: date);
    }
  }

  Future<Memory?> save({String? id}) async {
    if (state.content.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter a memory.');
      return null;
    }

    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      final now = DateTime.now();
      final memory = Memory(
        id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        content: state.content.trim(),
        createdAt: now,
        updatedAt: now,
        category: state.category,
        tags: state.tags,
        sourceType: state.sourceType,
        reminderDate: state.reminderDate,
      );

      final saved = await createMemoryUseCase(memory);

      if (saved.reminderDate != null && scheduleReminderUseCase != null) {
        try {
          await scheduleReminderUseCase!(
            Reminder(
              memoryId: saved.id,
              title: 'Memory Reminder',
              body: saved.content,
              scheduledDate: saved.reminderDate!,
            ),
          );
        } catch (_) {}
      }

      state = const AddMemoryState();
      return saved;
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: 'Failed to save memory.');
      return null;
    }
  }
}

final addMemoryNotifierProvider =
    StateNotifierProvider.autoDispose<AddMemoryNotifier, AddMemoryState>((ref) {
  final createUseCase = ref.watch(createMemoryUseCaseProvider);
  final scheduleUseCase = ref.watch(scheduleReminderUseCaseProvider);
  return AddMemoryNotifier(createUseCase, scheduleUseCase);
});
