import 'package:drift/drift.dart';
import '../../../../database/app_database.dart';
import '../../../memory/data/models/memory_dto.dart';
import '../../../memory/domain/entities/memory.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/repositories/memory_search_engine.dart';

class LocalMemorySearchEngine implements MemorySearchEngine {
  final AppDatabase db;

  LocalMemorySearchEngine(this.db);

  @override
  Future<SearchResult> search(String query, {int limit = 10}) async {
    final cleaned = query.trim();
    if (cleaned.isEmpty) {
      return SearchResult(query: query, matches: const []);
    }

    final terms = cleaned
        .split(RegExp(r'\s+'))
        .where((t) => t.length > 1)
        .map((t) => '"$t*"')
        .join(' OR ');

    final ftsQuery = terms.isNotEmpty ? terms : '"$cleaned*"';

    try {
      // Execute FTS5 virtual table query
      final rows = await db.customSelect(
        '''
        SELECT fts.id, m.*, bm25(memories_fts) as score
        FROM memories_fts fts
        JOIN memories m ON m.id = fts.id
        WHERE memories_fts MATCH ?
        ORDER BY score ASC
        LIMIT ?
        ''',
        variables: [Variable.withString(ftsQuery), Variable.withInt(limit)],
      ).get();

      final List<Memory> matches = [];
      final Map<String, double> scores = {};

      for (final row in rows) {
        final entry = db.memories.map(row.data);
        final dto = MemoryDto.fromEntry(entry);
        final memory = dto.toDomain();
        matches.add(memory);
        final score = (row.data['score'] as num?)?.toDouble() ?? 0.0;
        scores[memory.id] = score;
      }

      // Fallback to SQLite LIKE query if FTS returns no matches
      if (matches.isEmpty) {
        final likeQuery = '%$cleaned%';
        final fallbackEntries = await (db.select(db.memories)
              ..where((tbl) => tbl.content.like(likeQuery) | tbl.category.like(likeQuery) | tbl.tags.like(likeQuery))
              ..limit(limit))
            .get();

        for (final entry in fallbackEntries) {
          final dto = MemoryDto.fromEntry(entry);
          matches.add(dto.toDomain());
        }
      }

      return SearchResult(query: query, matches: matches, scores: scores);
    } catch (_) {
      // Substring fallback
      final likeQuery = '%$cleaned%';
      final fallbackEntries = await (db.select(db.memories)
            ..where((tbl) => tbl.content.like(likeQuery))
            ..limit(limit))
          .get();

      final matches = fallbackEntries.map((e) => MemoryDto.fromEntry(e).toDomain()).toList();
      return SearchResult(query: query, matches: matches);
    }
  }
}
