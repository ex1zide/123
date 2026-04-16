import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/chat_repository.dart';
import '../../data/providers/subscription_provider.dart';

part 'chat_controller.g.dart';

/// Single message entity.
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String,
      text: map['text'] as String,
      isUser: map['isUser'] as bool,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}

/// Controls the chat state as an AsyncValue list of messages.
/// State transitions handle loading (AI typing) and errors (API errors).
@riverpod
class ChatController extends _$ChatController {
  static const _cacheKey = 'chat_messages_cache';

  @override
  FutureOr<List<ChatMessage>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedStr = prefs.getString(_cacheKey);
    if (cachedStr != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(cachedStr);
        return jsonList.map((e) => ChatMessage.fromMap(e as Map<String, dynamic>)).toList();
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  Future<void> _saveToCache(List<ChatMessage> msgs) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = msgs.map((m) => m.toMap()).toList();
    await prefs.setString(_cacheKey, jsonEncode(jsonList));
  }

  /// Sends a message and updates the AsyncValue state accordingly.
  /// Returns `true` if sent, `false` if the free limit was exceeded.
  Future<bool> sendMessage(String text) async {
    final repo = ref.read(chatRepositoryProvider);
    final previousMessages = state.asData?.value ?? [];
    
    // Check subscription limits via the subscription provider
    final subState = ref.read(subscriptionControllerProvider).value;
    if (subState != null && subState.isLimitReached) {
      return false; // Show paywall
    }

    // Consume a query from the subscription quota
    if (subState != null && !subState.isPaid) {
      await ref.read(subscriptionControllerProvider.notifier).consumeQuery();
    }

    // Append user message immediately
    final userMsg = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    final updatedMessages = [...previousMessages, userMsg];

    // Transition to loading state, preserving the messages so UI doesn't flash
    state = const AsyncLoading<List<ChatMessage>>().copyWithPrevious(
      AsyncData(updatedMessages),
    );

    try {
      final aiText = await repo.getAiResponse(text);
      final aiMsg = ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: aiText,
        isUser: false,
        timestamp: DateTime.now(),
      );

      // Transition back to data state with the new AI message appended
      final updatedList = [...updatedMessages, aiMsg];
      state = AsyncData(updatedList);
      _saveToCache(updatedList);
      return true;
    } catch (e, st) {
      // Transition to error state, preserving the user message history
      state = AsyncError<List<ChatMessage>>(e, st).copyWithPrevious(
        AsyncData(updatedMessages),
      );
      return true; // Still "sent" the user message, error captured in state
    }
  }
}
