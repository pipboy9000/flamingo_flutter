import 'dart:convert';

import 'package:flamingo_flutter/database.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class FlashcardView extends StatefulWidget {
  const FlashcardView({super.key, required this.card});

  final Flashcard card;

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView> {
  bool _revealed = false;
  final AudioPlayer _player = AudioPlayer();

  List<MapEntry<String, String>> _breakdownEntries(String rawBreakdown) {
    try {
      final decoded = jsonDecode(rawBreakdown);
      if (decoded is Map<String, dynamic>) {
        return decoded.entries
            .map((entry) => MapEntry(entry.key, entry.value.toString()))
            .toList();
      }
    } catch (_) {
      // Ignore malformed breakdown data and render without it.
    }
    return const [];
  }

  @override
  void initState() {
    super.initState();
    _playAudio();
  }

  @override
  void didUpdateWidget(FlashcardView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.card.id != widget.card.id) {
      _revealed = false;
      _playAudio();
    }
  }

  Future<void> _playAudio() async {
    final assetPath = 'output/${widget.card.audioPath}';
    try {
      await _player.setAsset(assetPath);
      await _player.play();
    } catch (error) {
      debugPrint('Error playing audio for ${widget.card.original}: $error');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final breakdown = _breakdownEntries(card.breakdown);
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
                const SizedBox(height: 10),
                IconButton(
                  onPressed: _playAudio,
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                    size: 40,
                  ),
                  tooltip: 'Play audio',
                ),
                const Divider(height: 40),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _revealed
                      ? Column(
                          key: const ValueKey('revealed'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              card.translated,
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            if (breakdown.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: breakdown
                                      .map(
                                        (entry) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 6,
                                                height: 6,
                                                margin: const EdgeInsets.only(
                                                  top: 8,
                                                  right: 10,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Colors.black87,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Expanded(
                                                child: RichText(
                                                  text: TextSpan(
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                          color: Colors.black87,
                                                          height: 1.4,
                                                        ),
                                                    children: [
                                                      TextSpan(
                                                        text: '${entry.key}: ',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: entry.value,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ],
                        )
                      : Text(
                          'Tap to reveal',
                          key: const ValueKey('hidden'),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
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
