import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'word_details_screen.dart';

class VocabularySearchScreen extends ConsumerStatefulWidget {
  const VocabularySearchScreen({super.key});

  @override
  ConsumerState<VocabularySearchScreen> createState() =>
      _VocabularySearchScreenState();
}

class _VocabularySearchScreenState
    extends ConsumerState<VocabularySearchScreen> {
  final TextEditingController _controller = TextEditingController();

  void _search() {
    if (_controller.text.trim().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WordDetailsScreen(word: _controller.text.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book, size: 80, color: Colors.deepPurple),
          const SizedBox(height: 24),
          const Text(
            'Dictionary Search',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Search any word to get definitions, synonyms & antonyms!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _controller,
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
              hintText: 'Enter a word...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _search,
              ),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
