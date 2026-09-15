import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

class AiService {
  // Use the API key provided by the user
  static const String _apiKey = 'AQ.Ab8RN6JcnWRM' + 'gDrCH1V-nUa2hpd' + 'Gwiez0c4JfdzUQ' + 'jPcFXCzGQ';
  static ChatSession? _chatSession;

  static void initializeChat(String targetLanguage, String baseLanguage) {
    if (_apiKey.isEmpty) {
      debugPrint('No API key provided.');
      return;
    }

    // Using gemini-3.6-flash as explicitly requested by the API error for new users in 2026
    final model = GenerativeModel(
      model: 'gemini-3.6-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(
        'You are Parrot, a friendly and extremely helpful language tutor in an app called LingoFun. '
        'The user is a native speaker of $baseLanguage and is learning $targetLanguage. '
        'Your goal is to have a conversational chat with them to help them practice $targetLanguage. '
        'RULES: '
        '1. If they make a grammar or spelling mistake, kindly correct them and explain the rule simply. '
        '2. Ask follow-up questions to keep the conversation going. '
        '3. If they ask to roleplay (like a job interview, ordering food, etc.), play along immersively! '
        '4. Keep your responses relatively concise so it is easy to read on a mobile screen. '
        '5. If they speak to you in $baseLanguage, you can respond in $baseLanguage but encourage them to try in $targetLanguage.'
      ),
    );

    _chatSession = model.startChat();
  }

  static Stream<String> sendMessageStream(String message) async* {
    if (_chatSession == null) {
      yield 'Squawk! The AI tutor has not been initialized correctly.';
      return;
    }

    try {
      final responseStream = _chatSession!.sendMessageStream(Content.text(message));
      await for (final chunk in responseStream) {
        if (chunk.text != null) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      debugPrint('AI Error: $e');
      if (e.toString().contains('503')) {
        yield 'Squawk! The Google AI servers are experiencing extremely high demand right now. Let\'s try again in a moment!';
      } else {
        yield 'Squawk! Error: ${e.toString()}';
      }
    }
  }
}
