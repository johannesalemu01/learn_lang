import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../../core/services/api_services.dart';

final wordDetailsProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, word) async {
      final apiService = ApiService();
      return await apiService.fetchDictionaryWord(word);
    });

class WordDetailsScreen extends ConsumerStatefulWidget {
  final String word;

  const WordDetailsScreen({super.key, required this.word});

  @override
  ConsumerState<WordDetailsScreen> createState() => _WordDetailsScreenState();
}

class _WordDetailsScreenState extends ConsumerState<WordDetailsScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(wordDetailsProvider(widget.word));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.word,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () => _speak(widget.word),
          ),
        ],
      ),
      body: asyncData.when(
        data: (data) {
          if (data == null) {
            return const Center(
              child: Text("Word not found in dictionary limit."),
            );
          }

          final meanings = data['meanings'] as List<dynamic>? ?? [];
          final phonetic = data['phonetic'] ?? "";

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              if (phonetic.isNotEmpty)
                Text(
                  phonetic,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(height: 16),
              ...meanings.map((m) {
                final partOfSpeech = m['partOfSpeech'] ?? '';
                final definitions = m['definitions'] as List<dynamic>? ?? [];
                final synonyms = m['synonyms'] as List<dynamic>? ?? [];
                final antonyms = m['antonyms'] as List<dynamic>? ?? [];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          partOfSpeech.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const Divider(),
                        ...definitions.take(3).map((def) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "• ${def['definition']}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                if (def['example'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4.0,
                                      left: 16.0,
                                    ),
                                    child: Text(
                                      '"${def['example']}"',
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),

                        if (synonyms.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Text(
                            "Synonyms:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            spacing: 8,
                            children: synonyms
                                .take(5)
                                .map(
                                  (s) => ActionChip(
                                    label: Text(s),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              WordDetailsScreen(word: s),
                                        ),
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],

                        if (antonyms.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Text(
                            "Antonyms:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            spacing: 8,
                            children: antonyms
                                .take(5)
                                .map(
                                  (a) => ActionChip(
                                    label: Text(a),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              WordDetailsScreen(word: a),
                                        ),
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
