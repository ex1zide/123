import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/shimmer_placeholder.dart';

part 'history_screen.g.dart';

@riverpod
Stream<List<Map<String, dynamic>>> userHistory(UserHistoryRef ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('history')
      .orderBy('date', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
}

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(userHistoryProvider);
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.historyTitle),
      ),
      body: switch (historyAsync) {
        AsyncLoading() => ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) => const ShimmerPlaceholder(height: 100, borderRadius: 16),
          ),
        AsyncError(:final error) => Center(
            child: Text(l.historyError(error.toString()), style: TextStyle(color: theme.colorScheme.error)),
          ),
        AsyncData(:final value) => value.isEmpty
            ? Center(
                child: Text(
                  l.historyEmpty,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: value.length,
                itemBuilder: (context, index) {
                  final item = value[index];
                  final isAi = item['type'] == 'ai';
                  final title = item['title'] as String? ?? (isAi ? l.historyAiConsult : l.historyLawyerConsult);
                  final status = item['status'] as String? ?? 'completed'; // 'completed' | 'pending'
                  final timestamp = item['date'] as Timestamp?;
                  final dateStr = timestamp != null
                      ? '${timestamp.toDate().day.toString().padLeft(2, '0')}.${timestamp.toDate().month.toString().padLeft(2, '0')}.${timestamp.toDate().year}'
                      : l.historySoon;

                  return _HistoryCard(
                    title: title,
                    dateStr: dateStr,
                    isAi: isAi,
                    isPending: status == 'pending',
                  );
                },
              ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.title,
    required this.dateStr,
    required this.isAi,
    required this.isPending,
  });

  final String title;
  final String dateStr;
  final bool isAi;
  final bool isPending;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;
    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: isAi
                ? Colors.blueGrey.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.05),
            child: InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (isAi) {
                  // Push to chat with history context (assuming endpoint handles it)
                  context.push('/app/chat');
                } else {
                  context.push('/app/marketplace');
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isAi
                        ? Colors.blueGrey.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    // Icon Block
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isAi
                            ? Colors.blue.withValues(alpha: 0.1)
                            : gold.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isAi ? Icons.smart_toy_rounded : Icons.person_rounded,
                        color: isAi ? Colors.blue : gold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Info Block
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateStr,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Badge Block
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPending
                            ? gold.withValues(alpha: 0.1)
                            : Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isPending
                              ? gold.withValues(alpha: 0.3)
                              : Colors.green.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        isPending ? l.historyPending : l.historyCompleted,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isPending ? gold : Colors.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
