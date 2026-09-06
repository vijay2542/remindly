import 'package:drift/drift.dart';

@DataClassName('MemoryEntry')
class Memories extends Table {
  TextColumn get id => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get category => text().withDefault(const Constant('Other'))();
  TextColumn get tags => text().withDefault(const Constant('[]'))();
  TextColumn get sourceType => text().withDefault(const Constant('text'))();
  DateTimeColumn get reminderDate => dateTime().nullable()();
  TextColumn get location => text().nullable()();
  TextColumn get metadata => text().nullable()();
  BoolColumn get isSecure => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
