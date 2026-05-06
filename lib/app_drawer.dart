import 'package:flamingo_flutter/database.dart';
import 'package:flamingo_flutter/flashcards_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _DrawerRow {
  const _DrawerRow.header(this.category) : word = null;
  const _DrawerRow.word(this.word) : category = null;

  final String? category;
  final Flashcard? word;

  bool get isHeader => category != null;
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.onWordSelected});

  final void Function(Flashcard word) onWordSelected;

  @override
  Widget build(BuildContext context) {
    final flashcardsProvider = context.watch<FlashcardsProvider>();
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              child: Text("Quick Select"),
            ),
          ),
          Expanded(
            child: Builder(
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

                final rows = <_DrawerRow>[];
                for (final entry in grouped.entries) {
                  rows.add(_DrawerRow.header(entry.key));
                  rows.addAll(entry.value.map(_DrawerRow.word));
                }

                return ListView.builder(
                  itemCount: rows.length,
                  itemBuilder: (context, index) {
                    final row = rows[index];
                    if (row.isHeader) {
                      return Container(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        child: Text(
                          row.category!,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      );
                    }

                    final word = row.word!;
                    return ListTile(
                      title: Text(word.original),
                      // subtitle: Text(word.translated),
                      onTap: () {
                        Navigator.pop(context);
                        onWordSelected(word);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
