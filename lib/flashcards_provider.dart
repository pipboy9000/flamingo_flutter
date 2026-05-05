import 'package:flamingo_flutter/database.dart';
import 'package:flutter/foundation.dart';

class FlashcardsProvider extends ChangeNotifier {
  FlashcardsProvider(this._db);

  final AppDatabase _db;

  bool _isLoading = false;
  String? _error;
  List<Flashcard> _words = const [];

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Strips a leading "N-" priority prefix from a category name for display.
  static String displayCategory(String raw) {
    final match = RegExp(r'^\d+-(.+)$').firstMatch(raw);
    return match != null ? match.group(1)! : raw;
  }

  List<String> get categories => groupedByCategory.keys.toList();

  /// Returns categories sorted by their raw name (prefix included),
  /// keyed by the display name (prefix stripped).
  Map<String, List<Flashcard>> get groupedByCategory {
    final grouped = <String, List<Flashcard>>{};
    for (final word in _words) {
      grouped.putIfAbsent(word.category, () => []).add(word);
    }

    final sortedRawCategories = grouped.keys.toList()..sort();
    final sorted = <String, List<Flashcard>>{};
    for (final rawCategory in sortedRawCategories) {
      final items = List<Flashcard>.from(grouped[rawCategory]!);
      items.sort((a, b) => a.original.compareTo(b.original));
      sorted[displayCategory(rawCategory)] = items;
    }
    return sorted;
  }

  Future<void> loadWords() async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _words = await _db.select(_db.flashcards).get();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}