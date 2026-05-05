import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;
part 'database.g.dart';

class Flashcards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get original => text()();
  TextColumn get translated => text()();
  TextColumn get transliteration => text()();
  TextColumn get category => text()();
  TextColumn get breakdown => text()(); // JSON stringified Map
  TextColumn get audioPath => text()();
  IntColumn get proficiency => integer().withDefault(const Constant(0))();
  IntColumn get difficulty => integer().withDefault(const Constant(0))();
}

@DriftDatabase(tables: [Flashcards])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
  // Logic to seed the database
  Future<void> seedIfEmpty() async {
    final count = await select(flashcards).get().then((value) => value.length);
    if (count == 0) {
      final String response = await rootBundle.loadString(
        'output/dataset.json',
      );
      final List<dynamic> data = json.decode(response);
      await batch((batch) {
        batch.insertAll(
          flashcards,
          data.map((item) {
            return FlashcardsCompanion.insert(
              original: item['original'],
              translated: item['translated'],
              transliteration: item['transliteration'],
              category: item['category'],
              breakdown: json.encode(item['breakdown']),
              audioPath: item['audio_path'],
              proficiency: Value(item['proficiency'] ?? 0),
              difficulty: Value(item['difficulty'] ?? 0),
            );
          }).toList(),
        );
      });
    }
  }

}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
