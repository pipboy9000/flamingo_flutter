import 'package:flamingo_flutter/app_drawer.dart';
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

  String _categoryIconAsset(String category) {
    final fileName = '${category.replaceAll(' ', '-')}.png';
    return 'icons/$fileName';
  }

  Widget _buildCategoryCard(BuildContext context, String category, int wordCount) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: _categoryIconSize,
              height: _categoryIconSize,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
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
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category, style: Theme.of(context).textTheme.titleMedium),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final flashcardsProvider = context.watch<FlashcardsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flamingo'),
        // Flutter will automatically add the menu icon here
      ),
      drawer: const AppDrawer(),
      body: Builder(
        builder: (context) {
          if (flashcardsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (flashcardsProvider.error != null) {
            return Center(child: Text('Error: ${flashcardsProvider.error}'));
          }

          final grouped = flashcardsProvider.groupedByCategory;
          if (grouped.isEmpty) {
            return const Center(child: Text('No words found.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Text('Categories', style: Theme.of(context).textTheme.headlineSmall),
              // const SizedBox(height: 12),
              ...grouped.entries.map(
                (entry) => _buildCategoryCard(context, entry.key, entry.value.length),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
