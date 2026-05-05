// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FlashcardsTable extends Flashcards
    with TableInfo<$FlashcardsTable, Flashcard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlashcardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _originalMeta = const VerificationMeta(
    'original',
  );
  @override
  late final GeneratedColumn<String> original = GeneratedColumn<String>(
    'original',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translatedMeta = const VerificationMeta(
    'translated',
  );
  @override
  late final GeneratedColumn<String> translated = GeneratedColumn<String>(
    'translated',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transliterationMeta = const VerificationMeta(
    'transliteration',
  );
  @override
  late final GeneratedColumn<String> transliteration = GeneratedColumn<String>(
    'transliteration',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proficiencyMeta = const VerificationMeta(
    'proficiency',
  );
  @override
  late final GeneratedColumn<int> proficiency = GeneratedColumn<int>(
    'proficiency',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _breakdownMeta = const VerificationMeta(
    'breakdown',
  );
  @override
  late final GeneratedColumn<String> breakdown = GeneratedColumn<String>(
    'breakdown',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    original,
    translated,
    transliteration,
    category,
    proficiency,
    difficulty,
    breakdown,
    audioPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flashcards';
  @override
  VerificationContext validateIntegrity(
    Insertable<Flashcard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('original')) {
      context.handle(
        _originalMeta,
        original.isAcceptableOrUnknown(data['original']!, _originalMeta),
      );
    } else if (isInserting) {
      context.missing(_originalMeta);
    }
    if (data.containsKey('translated')) {
      context.handle(
        _translatedMeta,
        translated.isAcceptableOrUnknown(data['translated']!, _translatedMeta),
      );
    } else if (isInserting) {
      context.missing(_translatedMeta);
    }
    if (data.containsKey('transliteration')) {
      context.handle(
        _transliterationMeta,
        transliteration.isAcceptableOrUnknown(
          data['transliteration']!,
          _transliterationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transliterationMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('proficiency')) {
      context.handle(
        _proficiencyMeta,
        proficiency.isAcceptableOrUnknown(
          data['proficiency']!,
          _proficiencyMeta,
        ),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('breakdown')) {
      context.handle(
        _breakdownMeta,
        breakdown.isAcceptableOrUnknown(data['breakdown']!, _breakdownMeta),
      );
    } else if (isInserting) {
      context.missing(_breakdownMeta);
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    } else if (isInserting) {
      context.missing(_audioPathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Flashcard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Flashcard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      original: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original'],
      )!,
      translated: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translated'],
      )!,
      transliteration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transliteration'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      proficiency: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}proficiency'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      )!,
      breakdown: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}breakdown'],
      )!,
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      )!,
    );
  }

  @override
  $FlashcardsTable createAlias(String alias) {
    return $FlashcardsTable(attachedDatabase, alias);
  }
}

class Flashcard extends DataClass implements Insertable<Flashcard> {
  final int id;
  final String original;
  final String translated;
  final String transliteration;
  final String category;
  final int proficiency;
  final int difficulty;
  final String breakdown;
  final String audioPath;
  const Flashcard({
    required this.id,
    required this.original,
    required this.translated,
    required this.transliteration,
    required this.category,
    required this.proficiency,
    required this.difficulty,
    required this.breakdown,
    required this.audioPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['original'] = Variable<String>(original);
    map['translated'] = Variable<String>(translated);
    map['transliteration'] = Variable<String>(transliteration);
    map['category'] = Variable<String>(category);
    map['proficiency'] = Variable<int>(proficiency);
    map['difficulty'] = Variable<int>(difficulty);
    map['breakdown'] = Variable<String>(breakdown);
    map['audio_path'] = Variable<String>(audioPath);
    return map;
  }

  FlashcardsCompanion toCompanion(bool nullToAbsent) {
    return FlashcardsCompanion(
      id: Value(id),
      original: Value(original),
      translated: Value(translated),
      transliteration: Value(transliteration),
      category: Value(category),
      proficiency: Value(proficiency),
      difficulty: Value(difficulty),
      breakdown: Value(breakdown),
      audioPath: Value(audioPath),
    );
  }

  factory Flashcard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Flashcard(
      id: serializer.fromJson<int>(json['id']),
      original: serializer.fromJson<String>(json['original']),
      translated: serializer.fromJson<String>(json['translated']),
      transliteration: serializer.fromJson<String>(json['transliteration']),
      category: serializer.fromJson<String>(json['category']),
      proficiency: serializer.fromJson<int>(json['proficiency']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      breakdown: serializer.fromJson<String>(json['breakdown']),
      audioPath: serializer.fromJson<String>(json['audioPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'original': serializer.toJson<String>(original),
      'translated': serializer.toJson<String>(translated),
      'transliteration': serializer.toJson<String>(transliteration),
      'category': serializer.toJson<String>(category),
      'proficiency': serializer.toJson<int>(proficiency),
      'difficulty': serializer.toJson<int>(difficulty),
      'breakdown': serializer.toJson<String>(breakdown),
      'audioPath': serializer.toJson<String>(audioPath),
    };
  }

  Flashcard copyWith({
    int? id,
    String? original,
    String? translated,
    String? transliteration,
    String? category,
    int? proficiency,
    int? difficulty,
    String? breakdown,
    String? audioPath,
  }) => Flashcard(
    id: id ?? this.id,
    original: original ?? this.original,
    translated: translated ?? this.translated,
    transliteration: transliteration ?? this.transliteration,
    category: category ?? this.category,
    proficiency: proficiency ?? this.proficiency,
    difficulty: difficulty ?? this.difficulty,
    breakdown: breakdown ?? this.breakdown,
    audioPath: audioPath ?? this.audioPath,
  );
  Flashcard copyWithCompanion(FlashcardsCompanion data) {
    return Flashcard(
      id: data.id.present ? data.id.value : this.id,
      original: data.original.present ? data.original.value : this.original,
      translated: data.translated.present
          ? data.translated.value
          : this.translated,
      transliteration: data.transliteration.present
          ? data.transliteration.value
          : this.transliteration,
      category: data.category.present ? data.category.value : this.category,
      proficiency: data.proficiency.present
          ? data.proficiency.value
          : this.proficiency,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      breakdown: data.breakdown.present ? data.breakdown.value : this.breakdown,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Flashcard(')
          ..write('id: $id, ')
          ..write('original: $original, ')
          ..write('translated: $translated, ')
          ..write('transliteration: $transliteration, ')
          ..write('category: $category, ')
          ..write('proficiency: $proficiency, ')
          ..write('difficulty: $difficulty, ')
          ..write('breakdown: $breakdown, ')
          ..write('audioPath: $audioPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    original,
    translated,
    transliteration,
    category,
    proficiency,
    difficulty,
    breakdown,
    audioPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Flashcard &&
          other.id == this.id &&
          other.original == this.original &&
          other.translated == this.translated &&
          other.transliteration == this.transliteration &&
          other.category == this.category &&
          other.proficiency == this.proficiency &&
          other.difficulty == this.difficulty &&
          other.breakdown == this.breakdown &&
          other.audioPath == this.audioPath);
}

class FlashcardsCompanion extends UpdateCompanion<Flashcard> {
  final Value<int> id;
  final Value<String> original;
  final Value<String> translated;
  final Value<String> transliteration;
  final Value<String> category;
  final Value<int> proficiency;
  final Value<int> difficulty;
  final Value<String> breakdown;
  final Value<String> audioPath;
  const FlashcardsCompanion({
    this.id = const Value.absent(),
    this.original = const Value.absent(),
    this.translated = const Value.absent(),
    this.transliteration = const Value.absent(),
    this.category = const Value.absent(),
    this.proficiency = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.breakdown = const Value.absent(),
    this.audioPath = const Value.absent(),
  });
  FlashcardsCompanion.insert({
    this.id = const Value.absent(),
    required String original,
    required String translated,
    required String transliteration,
    required String category,
    this.proficiency = const Value.absent(),
    this.difficulty = const Value.absent(),
    required String breakdown,
    required String audioPath,
  }) : original = Value(original),
       translated = Value(translated),
       transliteration = Value(transliteration),
       category = Value(category),
       breakdown = Value(breakdown),
       audioPath = Value(audioPath);
  static Insertable<Flashcard> custom({
    Expression<int>? id,
    Expression<String>? original,
    Expression<String>? translated,
    Expression<String>? transliteration,
    Expression<String>? category,
    Expression<int>? proficiency,
    Expression<int>? difficulty,
    Expression<String>? breakdown,
    Expression<String>? audioPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (original != null) 'original': original,
      if (translated != null) 'translated': translated,
      if (transliteration != null) 'transliteration': transliteration,
      if (category != null) 'category': category,
      if (proficiency != null) 'proficiency': proficiency,
      if (difficulty != null) 'difficulty': difficulty,
      if (breakdown != null) 'breakdown': breakdown,
      if (audioPath != null) 'audio_path': audioPath,
    });
  }

  FlashcardsCompanion copyWith({
    Value<int>? id,
    Value<String>? original,
    Value<String>? translated,
    Value<String>? transliteration,
    Value<String>? category,
    Value<int>? proficiency,
    Value<int>? difficulty,
    Value<String>? breakdown,
    Value<String>? audioPath,
  }) {
    return FlashcardsCompanion(
      id: id ?? this.id,
      original: original ?? this.original,
      translated: translated ?? this.translated,
      transliteration: transliteration ?? this.transliteration,
      category: category ?? this.category,
      proficiency: proficiency ?? this.proficiency,
      difficulty: difficulty ?? this.difficulty,
      breakdown: breakdown ?? this.breakdown,
      audioPath: audioPath ?? this.audioPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (original.present) {
      map['original'] = Variable<String>(original.value);
    }
    if (translated.present) {
      map['translated'] = Variable<String>(translated.value);
    }
    if (transliteration.present) {
      map['transliteration'] = Variable<String>(transliteration.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (proficiency.present) {
      map['proficiency'] = Variable<int>(proficiency.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (breakdown.present) {
      map['breakdown'] = Variable<String>(breakdown.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardsCompanion(')
          ..write('id: $id, ')
          ..write('original: $original, ')
          ..write('translated: $translated, ')
          ..write('transliteration: $transliteration, ')
          ..write('category: $category, ')
          ..write('proficiency: $proficiency, ')
          ..write('difficulty: $difficulty, ')
          ..write('breakdown: $breakdown, ')
          ..write('audioPath: $audioPath')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FlashcardsTable flashcards = $FlashcardsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [flashcards];
}

typedef $$FlashcardsTableCreateCompanionBuilder =
    FlashcardsCompanion Function({
      Value<int> id,
      required String original,
      required String translated,
      required String transliteration,
      required String category,
      Value<int> proficiency,
      Value<int> difficulty,
      required String breakdown,
      required String audioPath,
    });
typedef $$FlashcardsTableUpdateCompanionBuilder =
    FlashcardsCompanion Function({
      Value<int> id,
      Value<String> original,
      Value<String> translated,
      Value<String> transliteration,
      Value<String> category,
      Value<int> proficiency,
      Value<int> difficulty,
      Value<String> breakdown,
      Value<String> audioPath,
    });

class $$FlashcardsTableFilterComposer
    extends Composer<_$AppDatabase, $FlashcardsTable> {
  $$FlashcardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get original => $composableBuilder(
    column: $table.original,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translated => $composableBuilder(
    column: $table.translated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get proficiency => $composableBuilder(
    column: $table.proficiency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get breakdown => $composableBuilder(
    column: $table.breakdown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FlashcardsTableOrderingComposer
    extends Composer<_$AppDatabase, $FlashcardsTable> {
  $$FlashcardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get original => $composableBuilder(
    column: $table.original,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translated => $composableBuilder(
    column: $table.translated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get proficiency => $composableBuilder(
    column: $table.proficiency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get breakdown => $composableBuilder(
    column: $table.breakdown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FlashcardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlashcardsTable> {
  $$FlashcardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get original =>
      $composableBuilder(column: $table.original, builder: (column) => column);

  GeneratedColumn<String> get translated => $composableBuilder(
    column: $table.translated,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get proficiency => $composableBuilder(
    column: $table.proficiency,
    builder: (column) => column,
  );

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get breakdown =>
      $composableBuilder(column: $table.breakdown, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);
}

class $$FlashcardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlashcardsTable,
          Flashcard,
          $$FlashcardsTableFilterComposer,
          $$FlashcardsTableOrderingComposer,
          $$FlashcardsTableAnnotationComposer,
          $$FlashcardsTableCreateCompanionBuilder,
          $$FlashcardsTableUpdateCompanionBuilder,
          (
            Flashcard,
            BaseReferences<_$AppDatabase, $FlashcardsTable, Flashcard>,
          ),
          Flashcard,
          PrefetchHooks Function()
        > {
  $$FlashcardsTableTableManager(_$AppDatabase db, $FlashcardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlashcardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlashcardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlashcardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> original = const Value.absent(),
                Value<String> translated = const Value.absent(),
                Value<String> transliteration = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> proficiency = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<String> breakdown = const Value.absent(),
                Value<String> audioPath = const Value.absent(),
              }) => FlashcardsCompanion(
                id: id,
                original: original,
                translated: translated,
                transliteration: transliteration,
                category: category,
                proficiency: proficiency,
                difficulty: difficulty,
                breakdown: breakdown,
                audioPath: audioPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String original,
                required String translated,
                required String transliteration,
                required String category,
                Value<int> proficiency = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                required String breakdown,
                required String audioPath,
              }) => FlashcardsCompanion.insert(
                id: id,
                original: original,
                translated: translated,
                transliteration: transliteration,
                category: category,
                proficiency: proficiency,
                difficulty: difficulty,
                breakdown: breakdown,
                audioPath: audioPath,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FlashcardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlashcardsTable,
      Flashcard,
      $$FlashcardsTableFilterComposer,
      $$FlashcardsTableOrderingComposer,
      $$FlashcardsTableAnnotationComposer,
      $$FlashcardsTableCreateCompanionBuilder,
      $$FlashcardsTableUpdateCompanionBuilder,
      (Flashcard, BaseReferences<_$AppDatabase, $FlashcardsTable, Flashcard>),
      Flashcard,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FlashcardsTableTableManager get flashcards =>
      $$FlashcardsTableTableManager(_db, _db.flashcards);
}
