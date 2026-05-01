import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../core/services/api_services.dart';

// Service Provider
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// State classes
class HomeState {
  final String inputText;
  final String searchQuery;
  final String sourceLanguage;
  final String targetLanguage;
  final WordOfDay wordOfDay;
  final List<WordOfDay> previousWordsOfDay;
  final List<TranslationItem> recentTranslations;
  final int selectedTabIndex;
  final bool isTranslating;

  HomeState({
    required this.inputText,
    this.searchQuery = '',
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.wordOfDay,
    required this.previousWordsOfDay,
    required this.recentTranslations,
    required this.selectedTabIndex,
    this.isTranslating = false,
  });

  HomeState copyWith({
    String? inputText,
    String? searchQuery,
    String? sourceLanguage,
    String? targetLanguage,
    WordOfDay? wordOfDay,
    List<WordOfDay>? previousWordsOfDay,
    List<TranslationItem>? recentTranslations,
    int? selectedTabIndex,
    bool? isTranslating,
  }) {
    return HomeState(
      inputText: inputText ?? this.inputText,
      searchQuery: searchQuery ?? this.searchQuery,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      wordOfDay: wordOfDay ?? this.wordOfDay,
      previousWordsOfDay: previousWordsOfDay ?? this.previousWordsOfDay,
      recentTranslations: recentTranslations ?? this.recentTranslations,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isTranslating: isTranslating ?? this.isTranslating,
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
  final ApiService _apiService;
  final FlutterTts _flutterTts = FlutterTts();

  HomeNotifier(this._apiService)
    : super(
        HomeState(
          inputText: '',
          searchQuery: '',
          sourceLanguage: 'EN',
          targetLanguage: 'FR',
          selectedTabIndex: 0,
          isTranslating: false,
          wordOfDay: WordOfDay(
            word: 'Efflorescence',
            pronunciation: '/ˌefləˈresns/',
            meaning: 'The state or a period of flowering.',
            example: 'The efflorescence of nature in spring is beautiful.',
          ),
          previousWordsOfDay: [
            WordOfDay(
              word: 'Serendipity',
              pronunciation: '/ˌserənˈdipəti/',
              meaning:
                  'The occurrence and development of events by chance in a happy or beneficial way.',
              example: 'Finding that old book was a moment of serendipity.',
            ),
            WordOfDay(
              word: 'Ephemeral',
              pronunciation: '/ˌəˈfem(ə)rəl/',
              meaning: 'Lasting for a very short time.',
              example: 'Fashions are ephemeral.',
            ),
            WordOfDay(
              word: 'Petrichor',
              pronunciation: '/ˈpetrīˌkôr/',
              meaning:
                  'A pleasant smell that frequently accompanies the first rain after a long period of warm, dry weather.',
              example:
                  'Other than the petrichor emanating from the rapidly drying grass, there was not a trace of evidence that it had rained.',
            ),
          ],
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

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(text);
  }

  void swapLanguages() {
    state = state.copyWith(
      sourceLanguage: state.targetLanguage,
      targetLanguage: state.sourceLanguage,
    );
  }

  void setSourceLanguage(String lang) {
    state = state.copyWith(sourceLanguage: lang);
  }

  void setTargetLanguage(String lang) {
    state = state.copyWith(targetLanguage: lang);
  }

  Future<void> translate() async {
    if (state.inputText.isEmpty || state.isTranslating) return;

    state = state.copyWith(isTranslating: true);

    final translation = await _apiService.translateText(
      text: state.inputText,
      sourceLanguage: state.sourceLanguage,
      targetLanguage: state.targetLanguage,
    );

    final newItem = TranslationItem(
      original: state.inputText,
      translated: translation,
      sourceLanguage: state.sourceLanguage,
      targetLanguage: state.targetLanguage,
    );

    state = state.copyWith(
      recentTranslations: [newItem, ...state.recentTranslations],
      inputText: '', // Clear input or keep it based on preference
      isTranslating: false,
    );
  }

  void saveWordOfDay() {
    // Logic to save word (mock)
    print('Saved word: ${state.wordOfDay.word}');
  }

  void setTabIndex(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }
}

// Provider
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return HomeNotifier(apiService);
});
