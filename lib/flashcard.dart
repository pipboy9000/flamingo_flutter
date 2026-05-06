import 'package:flamingo_flutter/database.dart';
import 'package:flutter/material.dart';

class FlashcardView extends StatefulWidget {
  const FlashcardView({super.key, required this.card});

  final Flashcard card;

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView> {
  bool _revealed = false;

  @override
  void didUpdateWidget(FlashcardView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.card.id != widget.card.id) {
      _revealed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    return GestureDetector(
      onTap: () => setState(() => _revealed = !_revealed),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  card.original,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                if (card.transliteration.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    card.transliteration,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const Divider(height: 40),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _revealed
                      ? Text(
                          card.translated,
                          key: const ValueKey('revealed'),
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          'Tap to reveal',
                          key: const ValueKey('hidden'),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}