import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'knowledge_repository.g.dart';

/// RAG (Retrieval-Augmented Generation) Knowledge Repository.
///
/// Searches the Firestore `knowledge_base` collection for articles
/// relevant to the user's legal question, then builds a context string
/// for the Gemini AI to ground its answer in real Kazakh legislation.
@Riverpod(keepAlive: true)
KnowledgeRepository knowledgeRepository(KnowledgeRepositoryRef ref) {
  return KnowledgeRepository(FirebaseFirestore.instance);
}

class KnowledgeRepository {
  KnowledgeRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static const _collectionPath = 'knowledge_base';
  static const _maxResults = 5;

  /// Searches the knowledge base for articles matching [query].
  /// Returns a list of [LegalArticle] sorted by relevance.
  Future<List<LegalArticle>> searchRelevantArticles(String query) async {
    try {
      // Normalize the query into keywords for Firestore array-contains-any
      final keywords = _extractKeywords(query);

      if (keywords.isEmpty) {
        return [];
      }

      // Firestore doesn't support full-text search natively.
      // We use a `keywords` array field on each document for tag-based matching.
      final snapshot = await _firestore
          .collection(_collectionPath)
          .where('keywords', arrayContainsAny: keywords.take(10).toList())
          .limit(_maxResults)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return LegalArticle(
          id: doc.id,
          title: data['title'] as String? ?? '',
          codeName: data['codeName'] as String? ?? '',
          articleNumber: data['articleNumber'] as String? ?? '',
          content: data['content'] as String? ?? '',
          keywords: List<String>.from(data['keywords'] ?? []),
        );
      }).toList();
    } catch (e) {
      // Fail gracefully — AI will respond without context
      return [];
    }
  }

  /// Builds a grounded context string from retrieved articles
  /// to inject into the Gemini system prompt.
  String buildContextPrompt(List<LegalArticle> articles) {
    if (articles.isEmpty) {
      return 'КОНТЕКСТ: Релевантные статьи законодательства РК не найдены в базе данных. '
          'Если вопрос требует ссылки на конкретные нормы — предложи пользователю '
          'обратиться к живому юристу через маркетплейс.';
    }

    final buffer = StringBuffer('КОНТЕКСТ ЗАКОНОДАТЕЛЬСТВА РК:\n\n');

    for (final article in articles) {
      buffer.writeln('━━━ ${article.codeName}, ${article.articleNumber} ━━━');
      buffer.writeln('Заголовок: ${article.title}');
      buffer.writeln('Текст: ${article.content}');
      buffer.writeln();
    }

    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('СТРОГО отвечай на основе приведенного контекста.');

    return buffer.toString();
  }

  /// Simple keyword extraction from user query.
  /// In production, replace with a proper NLP tokenizer or embeddings.
  List<String> _extractKeywords(String query) {
    final stopWords = {
      'и', 'в', 'на', 'за', 'к', 'по', 'из', 'о', 'у', 'с',
      'что', 'как', 'это', 'мне', 'мой', 'для', 'не', 'да',
      'ли', 'но', 'а', 'же', 'бы', 'от', 'до', 'при',
    };

    return query
        .toLowerCase()
        .replaceAll(RegExp(r'[^\wа-яёәіңғүұқөһ\s]'), '')
        .split(RegExp(r'\s+'))
        .where((word) => word.length > 2 && !stopWords.contains(word))
        .toSet()
        .toList();
  }
}

/// Data model for a legal article from the knowledge base.
class LegalArticle {
  const LegalArticle({
    required this.id,
    required this.title,
    required this.codeName,
    required this.articleNumber,
    required this.content,
    required this.keywords,
  });

  final String id;
  final String title;
  final String codeName;
  final String articleNumber;
  final String content;
  final List<String> keywords;
}
