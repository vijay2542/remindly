import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/memories_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Memories])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'remindly_db');
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();

        // Create FTS5 table for full-text search and BM25 ranking
        await customStatement('''
          CREATE VIRTUAL TABLE IF NOT EXISTS memories_fts USING fts5(
            id UNINDEXED,
            content,
            category,
            tags,
            tokenize = 'unicode61'
          );
        ''');

        // Triggers to keep FTS5 virtual table synchronized with Memories table
        await customStatement('''
          CREATE TRIGGER IF NOT EXISTS memories_ai AFTER INSERT ON memories BEGIN
            INSERT INTO memories_fts(id, content, category, tags)
            VALUES (new.id, new.content, new.category, new.tags);
          END;
        ''');

        await customStatement('''
          CREATE TRIGGER IF NOT EXISTS memories_ad AFTER DELETE ON memories BEGIN
            DELETE FROM memories_fts WHERE id = old.id;
          END;
        ''');

        await customStatement('''
          CREATE TRIGGER IF NOT EXISTS memories_au AFTER UPDATE ON memories BEGIN
            DELETE FROM memories_fts WHERE id = old.id;
            INSERT INTO memories_fts(id, content, category, tags)
            VALUES (new.id, new.content, new.category, new.tags);
          END;
        ''');
      },
    );
  }
}
