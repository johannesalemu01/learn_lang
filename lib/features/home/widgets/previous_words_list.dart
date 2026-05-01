import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_provider.dart';
import '../../vocabulary/screens/word_details_screen.dart';

class PreviousWordsList extends ConsumerWidget {
  const PreviousWordsList({super.key});

  void _showWordDetails(BuildContext context, WidgetRef ref, WordOfDay word) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WordDetailsScreen(word: word.word),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final previousWords = state.previousWordsOfDay;
    // Basic filter based on search query
    final filteredWords = previousWords.where((w) {
      if (state.searchQuery.isEmpty) return true;
      return w.word.toLowerCase().contains(state.searchQuery.toLowerCase());
    }).toList();

    if (filteredWords.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No previous words found.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Previous Words of the Day',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredWords.length,
            itemBuilder: (context, index) {
              final word = filteredWords[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    word.word,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    word.meaning,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showWordDetails(context, ref, word),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
