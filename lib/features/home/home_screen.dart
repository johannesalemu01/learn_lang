import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/home_provider.dart';
import 'widgets/greeting_header.dart';
import 'widgets/quick_actions.dart';
import 'widgets/recent_list.dart';
import 'widgets/translate_card.dart';
import 'widgets/word_of_day_card.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/previous_words_list.dart';
import '../vocabulary/screens/vocabulary_search_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Widget _buildBody(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GreetingHeader(),
              HomeSearchBar(),
              WordOfDayCard(),
              QuickActions(),
              PreviousWordsList(),
            ],
          ),
        );
      case 1:
        return const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [SizedBox(height: 16), TranslateCard(), RecentList()],
          ),
        );
      case 2:
        return const VocabularySearchScreen();
      case 3:
        return const Center(child: Text('Profile (Coming Soon)'));
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);

    return Scaffold(
      body: SafeArea(child: _buildBody(state.selectedTabIndex)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: state.selectedTabIndex,
        onTap: notifier.setTabIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.translate),
            label: 'Translate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Vocabulary',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
