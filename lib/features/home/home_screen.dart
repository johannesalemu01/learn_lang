import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/home_provider.dart';
import 'widgets/greeting_header.dart';
import 'widgets/quick_actions.dart';
import 'widgets/recent_list.dart';
import 'widgets/translate_card.dart';
import 'widgets/word_of_day_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              GreetingHeader(),
              TranslateCard(),
              WordOfDayCard(),
              QuickActions(),
              RecentList(),
            ],
          ),
        ),
      ),
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
