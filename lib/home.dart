import 'dart:math';

import 'package:flamingo_flutter/app_drawer.dart';
import 'package:flamingo_flutter/database.dart';
import 'package:flamingo_flutter/flashcard.dart';
import 'package:flamingo_flutter/flashcards_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const double _categoryIconSize = 64;
  final Random _random = Random();

  Flashcard? _selectedFlashcard;
  String? _activeCategory;
  final Map<String, List<Flashcard>> _remainingByCategory = {};

  void _showFlashcard(Flashcard card) {
    setState(() {
      _selectedFlashcard = card;
      _activeCategory = card.category;
    });
  }

  void _showHome() {
    setState(() {
      _selectedFlashcard = null;
      _activeCategory = null;
    });
  }

  void _startCategorySession(List<Flashcard> words, {Flashcard? initial}) {
    if (words.isEmpty) return;

    final category = words.first.category;
    final remaining = List<Flashcard>.from(words);
    late final Flashcard selected;

    if (initial != null) {
      selected = initial;
      remaining.removeWhere((card) => card.id == initial.id);
    } else {
      final index = _random.nextInt(remaining.length);
      selected = remaining.removeAt(index);
    }

    setState(() {
      _selectedFlashcard = selected;
      _activeCategory = category;
      _remainingByCategory[category] = remaining;
    });
  }

  List<Flashcard> _categoryWords(
    FlashcardsProvider flashcardsProvider,
    String category,
  ) {
    return flashcardsProvider.groupedByCategory.values
        .expand((items) => items)
        .where((word) => word.category == category)
        .toList();
  }

  void _showWordFromDrawer(
    Flashcard card,
    FlashcardsProvider flashcardsProvider,
  ) {
    final words = _categoryWords(flashcardsProvider, card.category);
    _startCategorySession(words, initial: card);
  }

  void _showNextWord(FlashcardsProvider flashcardsProvider) {
    final selected = _selectedFlashcard;
    if (selected == null) return;

    final category = _activeCategory ?? selected.category;
    final words = _remainingByCategory[category] ??
        _categoryWords(flashcardsProvider, category)
          ..removeWhere((word) => word.id == selected.id);

    if (words.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No more new words in this category.')),
      );
      return;
    }

    final index = _random.nextInt(words.length);
    final next = words.removeAt(index);

    setState(() {
      _selectedFlashcard = next;
      _activeCategory = category;
      _remainingByCategory[category] = words;
    });
  }

  String _categoryIconAsset(String category) {
    final fileName = '${category.replaceAll(' ', '-')}.png';
    return 'images/icons/$fileName';
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String category,
    int wordCount,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: _categoryIconSize,
                height: _categoryIconSize,
                child: Image.asset(
                  _categoryIconAsset(category),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) {
                    return const ColoredBox(
                      color: Color(0x11000000),
                      child: Center(
                        child: Icon(Icons.category_outlined, size: 32),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$wordCount words',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flashcardsProvider = context.watch<FlashcardsProvider>();

    return PopScope(
      canPop: _selectedFlashcard == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _selectedFlashcard != null) {
          _showHome();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          iconTheme: const IconThemeData(color: Colors.white, size: 38),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'images/logo.png',
                height: 42,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              const Text('🇪🇸'),
            ],
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        drawer: AppDrawer(
          onWordSelected: (word) => _showWordFromDrawer(word, flashcardsProvider),
        ),
        floatingActionButton: _selectedFlashcard != null
            ? FloatingActionButton(
                onPressed: _showHome,
                tooltip: 'Back to home',
                child: const Icon(Icons.home),
              )
            : null,
        body: SafeArea(
          top: false,
          child: Builder(
            builder: (context) {
              if (flashcardsProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (flashcardsProvider.error != null) {
                return Center(child: Text('Error: ${flashcardsProvider.error}'));
              }

              if (_selectedFlashcard != null) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlashcardView(card: _selectedFlashcard!),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                              child: SizedBox(
                                width: 120,
                                height: 40,
                                child: ElevatedButton.icon(
                                  onPressed: () => _showNextWord(flashcardsProvider),
                                  icon: const Icon(Icons.navigate_next),
                                  label: const Text('Next'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              final grouped = flashcardsProvider.groupedByCategory;
              if (grouped.isEmpty) {
                return const Center(child: Text('No words found.'));
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...grouped.entries.map(
                    (entry) => _buildCategoryCard(
                      context,
                      entry.key,
                      entry.value.length,
                      () => _startCategorySession(entry.value),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
