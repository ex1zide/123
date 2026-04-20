import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository.g.dart';

/// A single chat message exchanged between the user and the AI.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
}

/// Custom exception thrown when the server returns 429 (limit reached).
/// The UI layer catches this to show the Paywall.
class PaywallRequiredException implements Exception {
  const PaywallRequiredException([this.message = 'Лимит бесплатных запросов исчерпан']);
  final String message;

  @override
  String toString() => message;
}

/// Server-side AI legal assistant service.
///
/// All logic (RAG, Gemini, rate limiting) runs on Firebase Cloud Functions.
/// The client only sends the question and receives the answer.
/// API keys NEVER touch the client binary.
@Riverpod(keepAlive: true)
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepository();
}

class ChatRepository {
  ChatRepository();

  final _askAI = FirebaseFunctions.instance.httpsCallable(
    'askAI',
    options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
  );

  /// Sends a question to the Cloud Function and returns the AI response.
  ///
  /// Throws [PaywallRequiredException] if the server responds with 429.
  /// Throws [Exception] for all other errors.
  Future<String> getAiResponse(String userMessage) async {
    try {
      final result = await _askAI.call<Map<String, dynamic>>({
        'question': userMessage,
      });

      final data = result.data;
      return (data['answer'] as String?) ??
          'Извините, я не смог сформулировать ответ.';
    } on FirebaseFunctionsException catch (e) {
      // 429 — Resource Exhausted → Show Paywall
      if (e.code == 'resource-exhausted') {
        throw const PaywallRequiredException();
      }
      // Auth errors
      if (e.code == 'unauthenticated') {
        throw Exception('Войдите в аккаунт для использования ИИ-юриста.');
      }
      // All other server errors
      throw Exception('Ошибка сервера: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при обращении к ИИ-Юристу: $e');
    }
  }
}
