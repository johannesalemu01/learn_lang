import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_provider.dart';

class TranslateCard extends ConsumerWidget {
  const TranslateCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Type to translate...',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.mic),
                    onPressed: () {
                      // Voice input mock
                    },
                  ),
                ),
                onChanged: notifier.updateInputText,
                maxLines: 3,
                minLines: 1,
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: state.sourceLanguage,
                          icon: const Icon(Icons.arrow_drop_down, size: 18),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          items: const [
                            DropdownMenuItem(value: 'EN', child: Text('EN')),
                            DropdownMenuItem(value: 'FR', child: Text('FR')),
                            DropdownMenuItem(value: 'ES', child: Text('ES')),
                            DropdownMenuItem(value: 'DE', child: Text('DE')),
                            DropdownMenuItem(value: 'IT', child: Text('IT')),
                            DropdownMenuItem(value: 'AM', child: Text('AM')),
                          ],
                          onChanged: (val) {
                            if (val != null) notifier.setSourceLanguage(val);
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.swap_horiz, color: Colors.blue),
                        onPressed: notifier.swapLanguages,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: state.targetLanguage,
                          icon: const Icon(Icons.arrow_drop_down, size: 18),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          items: const [
                            DropdownMenuItem(value: 'EN', child: Text('EN')),
                            DropdownMenuItem(value: 'FR', child: Text('FR')),
                            DropdownMenuItem(value: 'ES', child: Text('ES')),
                            DropdownMenuItem(value: 'DE', child: Text('DE')),
                            DropdownMenuItem(value: 'IT', child: Text('IT')),
                            DropdownMenuItem(value: 'AM', child: Text('AM')),
                          ],
                          onChanged: (val) {
                            if (val != null) notifier.setTargetLanguage(val);
                          },
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: state.isTranslating ? null : notifier.translate,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: state.isTranslating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Translate'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
