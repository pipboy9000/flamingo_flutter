import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;
part 'database.g.dart';

const String _datasetAssetPath = 'output/dataset.json';
const String _datasetFingerprintFileName = 'dataset.fingerprint';

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

  Future<void> seedIfEmpty() async {
    final response = await rootBundle.loadString(_datasetAssetPath);
    final currentFingerprint = _fingerprint(response);
    final fingerprintFile = await _datasetFingerprintFile();
    final storedFingerprint = await fingerprintFile.exists()
        ? await fingerprintFile.readAsString()
        : null;
    final count = await select(flashcards).get().then((value) => value.length);

    if (count == 0 || storedFingerprint != currentFingerprint) {
      final List<dynamic> data = json.decode(response);
      await transaction(() async {
        await delete(flashcards).go();
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
        await fingerprintFile.writeAsString(currentFingerprint);
      });
    }
  }

  Future<File> _datasetFingerprintFile() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    return File(p.join(dbFolder.path, _datasetFingerprintFileName));
  }

  String _fingerprint(String value) {
    var hash = 0x811C9DC5;
    for (final codeUnit in utf8.encode(value)) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash.toRadixString(16).padLeft(8, '0');
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
