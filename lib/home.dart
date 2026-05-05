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
              Text('Categories', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              ...grouped.entries.map(
                (entry) => Card(
                  child: ListTile(
                    title: Text(entry.key),
                    subtitle: Text('${entry.value.length} words'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
