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

  Flashcard? _selectedFlashcard;

  void _showFlashcard(Flashcard card) {
    setState(() => _selectedFlashcard = card);
  }

  void _showHome() {
    setState(() => _selectedFlashcard = null);
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
        drawer: AppDrawer(onWordSelected: _showFlashcard),
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
                return FlashcardView(card: _selectedFlashcard!);
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
                      () {
                        final words = entry.value;
                        final random = words[Random().nextInt(words.length)];
                        _showFlashcard(random);
                      },
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
