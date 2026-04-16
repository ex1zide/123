import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/l10n/app_localizations.dart';
import '../../widgets/shimmer_placeholder.dart';

part 'documents_screen.g.dart';

@riverpod
Stream<List<Map<String, dynamic>>> userDocuments(UserDocumentsRef ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('documents')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
}

class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docsAsync = ref.watch(userDocumentsProvider);
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.docsTitle),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l.docsFabSnackbar)),
          );
        },
        backgroundColor: gold,
        icon: const Icon(Icons.document_scanner_rounded, color: Color(0xFF1A1400)),
        label: Text(
          l.docsFab,
          style: const TextStyle(color: Color(0xFF1A1400), fontWeight: FontWeight.bold),
        ),
      ),
      body: switch (docsAsync) {
        AsyncLoading() => ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 4,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) => const ShimmerPlaceholder(height: 80, borderRadius: 16),
          ),
        AsyncError(:final error) => Center(
            child: Text(l.docsError(error.toString()), style: TextStyle(color: theme.colorScheme.error)),
          ),
        AsyncData(:final value) => value.isEmpty
            ? Center(
                child: Text(
                  l.docsEmpty,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
                itemCount: value.length,
                itemBuilder: (context, index) {
                  final doc = value[index];
                  final title = doc['title'] as String? ?? l.docsUntitled;
                  final timestamp = doc['createdAt'] as Timestamp?;
                  final dateStr = timestamp != null
                      ? '${timestamp.toDate().day.toString().padLeft(2, '0')}.${timestamp.toDate().month.toString().padLeft(2, '0')}.${timestamp.toDate().year}'
                      : l.docsJustNow;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: gold.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.description_rounded, color: gold),
                              ),
                              const SizedBox(width: 16),
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
                                      l.docsAdded(dateStr),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
