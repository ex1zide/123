import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'knowledge_repository.dart';

part 'chat_repository.g.dart';

/// A single chat message exchanged between the user and Gemini AI.
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

/// RAG-enhanced Gemini AI legal-assistant service.
///
/// For each user question:
/// 1. Retrieves relevant Kazakh legal articles from Firestore
/// 2. Injects them as grounded context into the Gemini prompt
/// 3. Returns a legally-grounded AI response
@Riverpod(keepAlive: true)
ChatRepository chatRepository(ChatRepositoryRef ref) {
  final knowledgeRepo = ref.read(knowledgeRepositoryProvider);
  return ChatRepository(knowledgeRepo);
}

class ChatRepository {
  ChatRepository(this._knowledgeRepo);

  final KnowledgeRepository _knowledgeRepo;
  static const _maxFreeMessages = 10;

  /// Enterprise-grade system instruction for Gemini.
  static const _systemPrompt =
      'Ты — корпоративный ИИ-юрист Республики Казахстан. '
      'Твоя задача — давать точные юридические консультации, '
      'строго основываясь на переданном контексте (законодательстве РК). '
      'КАТЕГОРИЧЕСКИ ЗАПРЕЩЕНО выдумывать статьи, нормы или факты. '
      'Если в переданном контексте нет ответа на вопрос пользователя, '
      'честно сообщи об этом и предложи обратиться к живому юристу '
      'через маркетплейс LegalHelp KZ. '
      'Формат ответа: структурированный, с нумерацией пунктов, '
      'ссылками на конкретные статьи и кодексы. '
      'Язык: отвечай на том языке, на котором задан вопрос.';

  /// The Gemini model instance.
  final _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: const String.fromEnvironment('GEMINI_API_KEY', defaultValue: 'YOUR_API_KEY_HERE'),
    systemInstruction: Content.system(_systemPrompt),
  );

  /// Returns `true` if the user has exceeded the free-tier limit.
  bool isLimitExceeded(int messageCount) {
    return messageCount >= _maxFreeMessages;
  }

  /// The maximum number of free messages allowed.
  int get maxFreeMessages => _maxFreeMessages;

  /// RAG-enhanced AI response pipeline:
  /// 1. Search knowledge base for relevant articles
  /// 2. Build grounded context prompt
  /// 3. Send combined prompt to Gemini
  Future<String> getAiResponse(String userMessage) async {
    try {
      // ── Step 1: RAG Retrieval ──
      final articles = await _knowledgeRepo.searchRelevantArticles(userMessage);

      // ── Step 2: Build grounded context ──
      final contextPrompt = _knowledgeRepo.buildContextPrompt(articles);

      // ── Step 3: Send to Gemini with context ──
      final fullPrompt = '$contextPrompt\n\nВОПРОС ПОЛЬЗОВАТЕЛЯ:\n$userMessage';
      final content = [Content.text(fullPrompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'Извините, я не смог сформулировать ответ.';
    } catch (e) {
      final errorStr = e.toString();
      if (errorStr.contains('API key not valid') || errorStr.contains('YOUR_API_KEY')) {
        throw Exception('Недействительный API-ключ Gemini. Замените YOUR_API_KEY_HERE на реальный ключ.');
      }
      throw Exception('Ошибка при обращении к ИИ-Юристу: $e');
    }
  }
}
