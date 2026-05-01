import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// State classes
class HomeState {
  final String inputText;
  final String sourceLanguage;
  final String targetLanguage;
  final WordOfDay wordOfDay;
  final List<TranslationItem> recentTranslations;
  final int selectedTabIndex;

  HomeState({
    required this.inputText,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.wordOfDay,
    required this.recentTranslations,
    required this.selectedTabIndex,
  });

  HomeState copyWith({
    String? inputText,
    String? sourceLanguage,
    String? targetLanguage,
    WordOfDay? wordOfDay,
    List<TranslationItem>? recentTranslations,
    int? selectedTabIndex,
  }) {
    return HomeState(
      inputText: inputText ?? this.inputText,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      wordOfDay: wordOfDay ?? this.wordOfDay,
      recentTranslations: recentTranslations ?? this.recentTranslations,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}

class WordOfDay {
  final String word;
  final String pronunciation;
  final String meaning;
  final String example;

  WordOfDay({
    required this.word,
    required this.pronunciation,
    required this.meaning,
    required this.example,
  });
}

class TranslationItem {
  final String original;
  final String translated;
  final String sourceLanguage;
  final String targetLanguage;

  TranslationItem({
    required this.original,
    required this.translated,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
}

// State Notifier
class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier()
    : super(
        HomeState(
          inputText: '',
          sourceLanguage: 'EN',
          targetLanguage: 'FR',
          selectedTabIndex: 0,
          wordOfDay: WordOfDay(
            word: 'Efflorescence',
            pronunciation: '/ˌefləˈresns/',
            meaning: 'The state or a period of flowering.',
            example: 'The efflorescence of nature in spring is beautiful.',
          ),
          recentTranslations: [
            TranslationItem(
              original: 'Hello',
              translated: 'Bonjour',
              sourceLanguage: 'EN',
              targetLanguage: 'FR',
            ),
            TranslationItem(
              original: 'Thank you',
              translated: 'Merci',
              sourceLanguage: 'EN',
              targetLanguage: 'FR',
            ),
          ],
        ),
      );

  void updateInputText(String text) {
    state = state.copyWith(inputText: text);
  }

  void swapLanguages() {
    state = state.copyWith(
      sourceLanguage: state.targetLanguage,
      targetLanguage: state.sourceLanguage,
    );
  }

  void translate() {
    if (state.inputText.isEmpty) return;

    // Simulate translation by appending to recent (mock implementation)
    final newItem = TranslationItem(
      original: state.inputText,
      translated: '${state.inputText} (translated)',
      sourceLanguage: state.sourceLanguage,
      targetLanguage: state.targetLanguage,
    );

    state = state.copyWith(
      recentTranslations: [newItem, ...state.recentTranslations],
      inputText: '', // Clear input or keep it based on preference
    );
  }

  void saveWordOfDay() {
    // Logic to save word (mock)
    print('Saved word: \${state.wordOfDay.word}');
  }

  void setTabIndex(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }
}

// Provider
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});
