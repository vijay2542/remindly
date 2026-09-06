// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MemoriesTable extends Memories
    with TableInfo<$MemoriesTable, MemoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Other'),
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('text'),
  );
  static const VerificationMeta _reminderDateMeta = const VerificationMeta(
    'reminderDate',
  );
  @override
  late final GeneratedColumn<DateTime> reminderDate = GeneratedColumn<DateTime>(
    'reminder_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSecureMeta = const VerificationMeta(
    'isSecure',
  );
  @override
  late final GeneratedColumn<bool> isSecure = GeneratedColumn<bool>(
    'is_secure',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_secure" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    createdAt,
    updatedAt,
    category,
    tags,
    sourceType,
    reminderDate,
    location,
    metadata,
    isSecure,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memories';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    }
    if (data.containsKey('reminder_date')) {
      context.handle(
        _reminderDateMeta,
        reminderDate.isAcceptableOrUnknown(
          data['reminder_date']!,
          _reminderDateMeta,
        ),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('is_secure')) {
      context.handle(
        _isSecureMeta,
        isSecure.isAcceptableOrUnknown(data['is_secure']!, _isSecureMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      reminderDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reminder_date'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
      isSecure: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_secure'],
      )!,
    );
  }

  @override
  $MemoriesTable createAlias(String alias) {
    return $MemoriesTable(attachedDatabase, alias);
  }
}

class MemoryEntry extends DataClass implements Insertable<MemoryEntry> {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String category;
  final String tags;
  final String sourceType;
  final DateTime? reminderDate;
  final String? location;
  final String? metadata;
  final bool isSecure;
  const MemoryEntry({
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
    required this.isSecure,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['category'] = Variable<String>(category);
    map['tags'] = Variable<String>(tags);
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || reminderDate != null) {
      map['reminder_date'] = Variable<DateTime>(reminderDate);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['is_secure'] = Variable<bool>(isSecure);
    return map;
  }

  MemoriesCompanion toCompanion(bool nullToAbsent) {
    return MemoriesCompanion(
      id: Value(id),
      content: Value(content),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      category: Value(category),
      tags: Value(tags),
      sourceType: Value(sourceType),
      reminderDate: reminderDate == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderDate),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      isSecure: Value(isSecure),
    );
  }

  factory MemoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryEntry(
      id: serializer.fromJson<String>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      category: serializer.fromJson<String>(json['category']),
      tags: serializer.fromJson<String>(json['tags']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      reminderDate: serializer.fromJson<DateTime?>(json['reminderDate']),
      location: serializer.fromJson<String?>(json['location']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      isSecure: serializer.fromJson<bool>(json['isSecure']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'category': serializer.toJson<String>(category),
      'tags': serializer.toJson<String>(tags),
      'sourceType': serializer.toJson<String>(sourceType),
      'reminderDate': serializer.toJson<DateTime?>(reminderDate),
      'location': serializer.toJson<String?>(location),
      'metadata': serializer.toJson<String?>(metadata),
      'isSecure': serializer.toJson<bool>(isSecure),
    };
  }

  MemoryEntry copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? category,
    String? tags,
    String? sourceType,
    Value<DateTime?> reminderDate = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<String?> metadata = const Value.absent(),
    bool? isSecure,
  }) => MemoryEntry(
    id: id ?? this.id,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    category: category ?? this.category,
    tags: tags ?? this.tags,
    sourceType: sourceType ?? this.sourceType,
    reminderDate: reminderDate.present ? reminderDate.value : this.reminderDate,
    location: location.present ? location.value : this.location,
    metadata: metadata.present ? metadata.value : this.metadata,
    isSecure: isSecure ?? this.isSecure,
  );
  MemoryEntry copyWithCompanion(MemoriesCompanion data) {
    return MemoryEntry(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      category: data.category.present ? data.category.value : this.category,
      tags: data.tags.present ? data.tags.value : this.tags,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      reminderDate: data.reminderDate.present
          ? data.reminderDate.value
          : this.reminderDate,
      location: data.location.present ? data.location.value : this.location,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      isSecure: data.isSecure.present ? data.isSecure.value : this.isSecure,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryEntry(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('category: $category, ')
          ..write('tags: $tags, ')
          ..write('sourceType: $sourceType, ')
          ..write('reminderDate: $reminderDate, ')
          ..write('location: $location, ')
          ..write('metadata: $metadata, ')
          ..write('isSecure: $isSecure')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    content,
    createdAt,
    updatedAt,
    category,
    tags,
    sourceType,
    reminderDate,
    location,
    metadata,
    isSecure,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryEntry &&
          other.id == this.id &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.category == this.category &&
          other.tags == this.tags &&
          other.sourceType == this.sourceType &&
          other.reminderDate == this.reminderDate &&
          other.location == this.location &&
          other.metadata == this.metadata &&
          other.isSecure == this.isSecure);
}

class MemoriesCompanion extends UpdateCompanion<MemoryEntry> {
  final Value<String> id;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> category;
  final Value<String> tags;
  final Value<String> sourceType;
  final Value<DateTime?> reminderDate;
  final Value<String?> location;
  final Value<String?> metadata;
  final Value<bool> isSecure;
  final Value<int> rowid;
  const MemoriesCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.category = const Value.absent(),
    this.tags = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.reminderDate = const Value.absent(),
    this.location = const Value.absent(),
    this.metadata = const Value.absent(),
    this.isSecure = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemoriesCompanion.insert({
    required String id,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.category = const Value.absent(),
    this.tags = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.reminderDate = const Value.absent(),
    this.location = const Value.absent(),
    this.metadata = const Value.absent(),
    this.isSecure = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       content = Value(content),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MemoryEntry> custom({
    Expression<String>? id,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? category,
    Expression<String>? tags,
    Expression<String>? sourceType,
    Expression<DateTime>? reminderDate,
    Expression<String>? location,
    Expression<String>? metadata,
    Expression<bool>? isSecure,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (category != null) 'category': category,
      if (tags != null) 'tags': tags,
      if (sourceType != null) 'source_type': sourceType,
      if (reminderDate != null) 'reminder_date': reminderDate,
      if (location != null) 'location': location,
      if (metadata != null) 'metadata': metadata,
      if (isSecure != null) 'is_secure': isSecure,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? category,
    Value<String>? tags,
    Value<String>? sourceType,
    Value<DateTime?>? reminderDate,
    Value<String?>? location,
    Value<String?>? metadata,
    Value<bool>? isSecure,
    Value<int>? rowid,
  }) {
    return MemoriesCompanion(
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (reminderDate.present) {
      map['reminder_date'] = Variable<DateTime>(reminderDate.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (isSecure.present) {
      map['is_secure'] = Variable<bool>(isSecure.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoriesCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('category: $category, ')
          ..write('tags: $tags, ')
          ..write('sourceType: $sourceType, ')
          ..write('reminderDate: $reminderDate, ')
          ..write('location: $location, ')
          ..write('metadata: $metadata, ')
          ..write('isSecure: $isSecure, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MemoriesTable memories = $MemoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [memories];
}

typedef $$MemoriesTableCreateCompanionBuilder = MemoriesCompanion Function({
  required String id,
  required String content,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String> category,
  Value<String> tags,
  Value<String> sourceType,
  Value<DateTime?> reminderDate,
  Value<String?> location,
  Value<String?> metadata,
  Value<bool> isSecure,
  Value<int> rowid,
});
typedef $$MemoriesTableUpdateCompanionBuilder = MemoriesCompanion Function({
  Value<String> id,
  Value<String> content,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> category,
  Value<String> tags,
  Value<String> sourceType,
  Value<DateTime?> reminderDate,
  Value<String?> location,
  Value<String?> metadata,
  Value<bool> isSecure,
  Value<int> rowid,
});

class $$MemoriesTableFilterComposer
    extends Composer<_$AppDatabase, $MemoriesTable> {
  $$MemoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reminderDate => $composableBuilder(
    column: $table.reminderDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSecure => $composableBuilder(
    column: $table.isSecure,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MemoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoriesTable> {
  $$MemoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reminderDate => $composableBuilder(
    column: $table.reminderDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSecure => $composableBuilder(
    column: $table.isSecure,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MemoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoriesTable> {
  $$MemoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get reminderDate => $composableBuilder(
    column: $table.reminderDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<bool> get isSecure =>
      $composableBuilder(column: $table.isSecure, builder: (column) => column);
}

class $$MemoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemoriesTable,
          MemoryEntry,
          $$MemoriesTableFilterComposer,
          $$MemoriesTableOrderingComposer,
          $$MemoriesTableAnnotationComposer,
          $$MemoriesTableCreateCompanionBuilder,
          $$MemoriesTableUpdateCompanionBuilder,
          (
            MemoryEntry,
            BaseReferences<_$AppDatabase, $MemoriesTable, MemoryEntry>,
          ),
          MemoryEntry,
          PrefetchHooks Function()
        > {
  $$MemoriesTableTableManager(_$AppDatabase db, $MemoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<DateTime?> reminderDate = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<bool> isSecure = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemoriesCompanion(
                id: id,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
                category: category,
                tags: tags,
                sourceType: sourceType,
                reminderDate: reminderDate,
                location: location,
                metadata: metadata,
                isSecure: isSecure,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String content,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String> category = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<DateTime?> reminderDate = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<bool> isSecure = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemoriesCompanion.insert(
                id: id,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
                category: category,
                tags: tags,
                sourceType: sourceType,
                reminderDate: reminderDate,
                location: location,
                metadata: metadata,
                isSecure: isSecure,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MemoriesTable, MemoryEntry>(table),
                  BaseReferences<_$AppDatabase, $MemoriesTable, MemoryEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MemoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemoriesTable,
      MemoryEntry,
      $$MemoriesTableFilterComposer,
      $$MemoriesTableOrderingComposer,
      $$MemoriesTableAnnotationComposer,
      $$MemoriesTableCreateCompanionBuilder,
      $$MemoriesTableUpdateCompanionBuilder,
      (MemoryEntry, BaseReferences<_$AppDatabase, $MemoriesTable, MemoryEntry>),
      MemoryEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MemoriesTableTableManager get memories =>
      $$MemoriesTableTableManager(_db, _db.memories);
}
