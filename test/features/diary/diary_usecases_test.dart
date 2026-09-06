import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:remindly/features/diary/domain/entities/diary_entry.dart';
import 'package:remindly/features/diary/domain/repositories/diary_repository.dart';
import 'package:remindly/features/diary/domain/usecases/create_diary_entry.dart';
import 'package:remindly/features/diary/domain/usecases/delete_diary_entry.dart';
import 'package:remindly/features/diary/domain/usecases/get_diary_entries.dart';
import 'package:remindly/features/diary/domain/usecases/get_diary_entry.dart';
import 'package:remindly/features/diary/domain/usecases/search_diary_entries.dart';
import 'package:remindly/features/diary/domain/usecases/update_diary_entry.dart';

class MockDiaryRepository extends Mock implements DiaryRepository {}

void main() {
  late MockDiaryRepository mockRepository;
  late CreateDiaryEntryUseCase createUseCase;
  late UpdateDiaryEntryUseCase updateUseCase;
  late DeleteDiaryEntryUseCase deleteUseCase;
  late GetDiaryEntryUseCase getUseCase;
  late GetDiaryEntriesUseCase getAllUseCase;
  late SearchDiaryEntriesUseCase searchUseCase;

  final testEntry = DiaryEntry(
    id: 'diary-1',
    title: 'Good Day',
    content: 'Today was very productive.',
    diaryDate: DateTime(2026, 9, 6),
    createdAt: DateTime(2026, 9, 6),
    updatedAt: DateTime(2026, 9, 6),
  );

  setUp(() {
    mockRepository = MockDiaryRepository();
    createUseCase = CreateDiaryEntryUseCase(mockRepository);
    updateUseCase = UpdateDiaryEntryUseCase(mockRepository);
    deleteUseCase = DeleteDiaryEntryUseCase(mockRepository);
    getUseCase = GetDiaryEntryUseCase(mockRepository);
    getAllUseCase = GetDiaryEntriesUseCase(mockRepository);
    searchUseCase = SearchDiaryEntriesUseCase(mockRepository);
  });

  group('Diary Use Cases Tests', () {
    test('CreateDiaryEntryUseCase creates entry via repository', () async {
      when(() => mockRepository.createEntry(testEntry)).thenAnswer((_) async => testEntry);

      final result = await createUseCase(testEntry);
      expect(result, equals(testEntry));
      verify(() => mockRepository.createEntry(testEntry)).called(1);
    });

    test('UpdateDiaryEntryUseCase updates entry via repository', () async {
      when(() => mockRepository.updateEntry(testEntry)).thenAnswer((_) async => testEntry);

      final result = await updateUseCase(testEntry);
      expect(result, equals(testEntry));
      verify(() => mockRepository.updateEntry(testEntry)).called(1);
    });

    test('DeleteDiaryEntryUseCase deletes entry by ID', () async {
      when(() => mockRepository.deleteEntry('diary-1')).thenAnswer((_) async {});

      await deleteUseCase('diary-1');
      verify(() => mockRepository.deleteEntry('diary-1')).called(1);
    });

    test('GetDiaryEntryUseCase retrieves entry by ID', () async {
      when(() => mockRepository.getEntryById('diary-1')).thenAnswer((_) async => testEntry);

      final result = await getUseCase('diary-1');
      expect(result, equals(testEntry));
      verify(() => mockRepository.getEntryById('diary-1')).called(1);
    });

    test('GetDiaryEntriesUseCase fetches all entries', () async {
      when(() => mockRepository.getAllEntries()).thenAnswer((_) async => [testEntry]);

      final results = await getAllUseCase();
      expect(results, equals([testEntry]));
      verify(() => mockRepository.getAllEntries()).called(1);
    });

    test('SearchDiaryEntriesUseCase returns matching entries', () async {
      when(() => mockRepository.searchEntries('productive')).thenAnswer((_) async => [testEntry]);

      final results = await searchUseCase('productive');
      expect(results, equals([testEntry]));
      verify(() => mockRepository.searchEntries('productive')).called(1);
    });

    test('DiaryEntry toString does not print sensitive content', () {
      final str = testEntry.toString();
      expect(str, contains('id: diary-1'));
      expect(str, contains('title: Good Day'));
      expect(str, isNot(contains('Today was very productive.')));
    });
  });
}
