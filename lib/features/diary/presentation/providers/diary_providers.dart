import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/memory/presentation/providers/memory_providers.dart';
import '../../data/datasources/diary_local_datasource.dart';
import '../../data/repositories/diary_repository_impl.dart';
import '../../domain/entities/diary_entry.dart';
import '../../domain/repositories/diary_repository.dart';
import '../../domain/usecases/create_diary_entry.dart';
import '../../domain/usecases/delete_diary_entry.dart';
import '../../domain/usecases/get_diary_entries.dart';
import '../../domain/usecases/get_diary_entry.dart';
import '../../domain/usecases/search_diary_entries.dart';
import '../../domain/usecases/update_diary_entry.dart';

final diaryLocalDatasourceProvider = Provider<DiaryLocalDatasource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DiaryLocalDatasourceImpl(db);
});

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  final datasource = ref.watch(diaryLocalDatasourceProvider);
  return DiaryRepositoryImpl(localDatasource: datasource);
});

final createDiaryEntryUseCaseProvider = Provider<CreateDiaryEntryUseCase>((ref) {
  final repo = ref.watch(diaryRepositoryProvider);
  return CreateDiaryEntryUseCase(repo);
});

final updateDiaryEntryUseCaseProvider = Provider<UpdateDiaryEntryUseCase>((ref) {
  final repo = ref.watch(diaryRepositoryProvider);
  return UpdateDiaryEntryUseCase(repo);
});

final deleteDiaryEntryUseCaseProvider = Provider<DeleteDiaryEntryUseCase>((ref) {
  final repo = ref.watch(diaryRepositoryProvider);
  return DeleteDiaryEntryUseCase(repo);
});

final getDiaryEntryUseCaseProvider = Provider<GetDiaryEntryUseCase>((ref) {
  final repo = ref.watch(diaryRepositoryProvider);
  return GetDiaryEntryUseCase(repo);
});

final getDiaryEntriesUseCaseProvider = Provider<GetDiaryEntriesUseCase>((ref) {
  final repo = ref.watch(diaryRepositoryProvider);
  return GetDiaryEntriesUseCase(repo);
});

final searchDiaryEntriesUseCaseProvider = Provider<SearchDiaryEntriesUseCase>((ref) {
  final repo = ref.watch(diaryRepositoryProvider);
  return SearchDiaryEntriesUseCase(repo);
});

final diaryEntriesStreamProvider = StreamProvider<List<DiaryEntry>>((ref) {
  final repo = ref.watch(diaryRepositoryProvider);
  return repo.watchEntries();
});

final selectedDiaryDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});
