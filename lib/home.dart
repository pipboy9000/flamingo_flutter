import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:flamingo_flutter/app_drawer.dart';
import 'package:flamingo_flutter/database.dart';
import 'package:flamingo_flutter/flashcard.dart';
import 'package:flamingo_flutter/flashcards_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const double _categoryIconSize = 64;
  final Random _random = Random();

  static String get _bannerAdUnitId {
    if (Platform.isAndroid) {
      return kReleaseMode
          ? 'ca-app-pub-5313838936547493/7772910761' //Change this when creating a new language
          : 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5313838936547493/6623710069'; //Change this when creating a new language
    }
    throw UnsupportedError('Unsupported platform for banner ads');
  }

  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  Flashcard? _selectedFlashcard;
  String? _activeCategory;
  final Map<String, List<Flashcard>> _remainingByCategory = {};
  final Map<String, List<Flashcard>> _historyByCategory = {};

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid || Platform.isIOS) {
      _bannerAd = BannerAd(
        adUnitId: _bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) => setState(() => _isBannerAdReady = true),
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            _bannerAd = null;
          },
        ),
      )..load();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

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
      _historyByCategory[category] = [selected];
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
    final history = List<Flashcard>.from(_historyByCategory[category] ?? [selected]);

    if (history.isEmpty || history.last.id != selected.id) {
      history.add(selected);
    }
    history.add(next);

    setState(() {
      _selectedFlashcard = next;
      _activeCategory = category;
      _remainingByCategory[category] = words;
      _historyByCategory[category] = history;
    });
  }

  bool _canShowPreviousWord() {
    final selected = _selectedFlashcard;
    if (selected == null) return false;

    final category = _activeCategory ?? selected.category;
    final history = _historyByCategory[category];
    return history != null && history.length > 1;
  }

  void _showPreviousWord() {
    final selected = _selectedFlashcard;
    if (selected == null) return;

    final category = _activeCategory ?? selected.category;
    final history = List<Flashcard>.from(_historyByCategory[category] ?? const []);

    if (history.length <= 1) {
      return;
    }

    final current = history.removeLast();
    final previous = history.last;
    final remaining = List<Flashcard>.from(_remainingByCategory[category] ?? const []);

    if (!remaining.any((card) => card.id == current.id)) {
      remaining.add(current);
    }

    setState(() {
      _selectedFlashcard = previous;
      _activeCategory = category;
      _remainingByCategory[category] = remaining;
      _historyByCategory[category] = history;
    });
  }

  Widget? _buildBannerAd() {
    if (!_isBannerAdReady || _bannerAd == null) return null;
    return SafeArea(
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
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
                      '$wordCount cards',
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
                height: 48,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              const Text('🇮🇱'),
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
                backgroundColor: Colors.white,
                child: const Icon(Icons.home),
              )
            : null,
        bottomNavigationBar: _buildBannerAd(),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    height: 40,
                                    child: ElevatedButton.icon(
                                      onPressed: _canShowPreviousWord()
                                          ? _showPreviousWord
                                          : null,
                                      icon: const Icon(Icons.navigate_before),
                                      label: const Text('Prev'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  SizedBox(
                                    width: 120,
                                    height: 40,
                                    child: ElevatedButton.icon(
                                      onPressed: () => _showNextWord(flashcardsProvider),
                                      icon: const Icon(Icons.navigate_next),
                                      label: const Text('Next'),
                                    ),
                                  ),
                                ],
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
