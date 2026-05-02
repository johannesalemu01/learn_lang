import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  ApiService();

  Dio _initDio() {
    return Dio(
      BaseOptions(
        baseUrl: 'https://api.langbly.com',
        headers: {
          'Authorization': 'Bearer ${dotenv.env['LANGBLY_API_KEY']}',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<String> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    try {
      final dio = _initDio();
      final response = await dio.post(
        '/language/translate/v2',
        data: {
          'q': text,
          'source': sourceLanguage.toLowerCase(),
          'target': targetLanguage.toLowerCase(),
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        if (data != null &&
            data['translations'] != null &&
            data['translations'].isNotEmpty) {
          return data['translations'][0]['translatedText'] ??
              'Translation missing in payload';
        }
      }
      return 'Translation failed: ${response.statusCode}';
    } catch (e) {
      print('Error during translation: $e');
      return 'Error: Could not connect to translation service';
    }
  }

  Future<Map<String, dynamic>?> fetchDictionaryWord(String word) async {
    try {
      final response = await Dio().get(
        'https://api.dictionaryapi.dev/api/v2/entries/en/$word',
      );
      if (response.statusCode == 200 &&
          response.data is List &&
          response.data.isNotEmpty) {
        return response.data[0] as Map<String, dynamic>;
      }
    } catch (e) {
      print('Dictionary error lookup for $word: $e');
      return null;
    }
    return null;
  }
}
