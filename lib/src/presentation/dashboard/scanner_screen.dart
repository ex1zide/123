import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:app/l10n/app_localizations.dart';

import 'scanner_controller.dart';
import '../widgets/shimmer_placeholder.dart';

class ScannerScreen extends ConsumerWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    // Listen to Errors specifically to isolate dialog overlays without breaking layout constraints.
    ref.listen<AsyncValue<String?>>(
      scannerControllerProvider,
      (_, state) {
        if (!state.isLoading && state.hasError) {
          final errorText = state.error.toString().replaceFirst('Exception: ', '');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorText),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );

    final scannerState = ref.watch(scannerControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: Text(l.scannerTitle),
      ),
      body: switch (scannerState) {
        AsyncLoading() => const _ProcessingState(),
        AsyncData(:final value) => value == null 
            ? const _EmptyState()
            : _ResultState(text: value),
        AsyncError() => const _EmptyState(), // Fallback empty if error occurred
        _ => const _EmptyState(),
      },
    );
  }
}

class _EmptyState extends ConsumerWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;
    final l = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: gold.withValues(alpha: 0.1),
                boxShadow: [
                  BoxShadow(
                    color: gold.withValues(alpha: 0.1),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                Icons.document_scanner_rounded,
                size: 80,
                color: gold,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              l.scannerEmptyTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l.scannerEmptyDesc,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: const Color(0xFF1A1400),
                  elevation: 8,
                  shadowColor: gold.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.camera_alt_rounded),
                label: Text(
                  l.scannerButton,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                onPressed: () {
                  ref.read(scannerControllerProvider.notifier).scanDocument();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProcessingState extends StatelessWidget {
  const _ProcessingState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: Text(
              l.scannerProcessing,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Efficient Skeleton loader enforcing 60FPS
          Expanded(
            child: ListView.separated(
              itemCount: 10,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return ShimmerPlaceholder(
                  height: index % 3 == 0 ? 20 : 14, 
                  borderRadius: 4,
                  width: index % 2 == 0 ? double.infinity : MediaQuery.of(context).size.width * 0.7,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultState extends ConsumerWidget {
  const _ResultState({required this.text});

  final String text;

  Future<void> _saveToDocs(BuildContext context, AppLocalizations l) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.scannerAuthRequired)),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('documents')
          .add({
        'title': l.scannerDocTitle,
        'content': text,
        'createdAt': FieldValue.serverTimestamp(),
        'type': 'ocr_scan',
      });
      
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.scannerSaved),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.scannerSaveError(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;
    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F0F0F).withValues(alpha: 0.6), // Glassmorphism Deep Black
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: gold.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Text(
                      text.isEmpty ? l.scannerNoText : text,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: gold,
                      side: BorderSide(color: gold.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.copy_rounded, size: 20),
                    label: Text(
                      l.scannerCopy,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l.scannerCopied)),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor: const Color(0xFF1A1400),
                      elevation: 8,
                      shadowColor: gold.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.save_rounded, size: 20),
                    label: Text(
                      l.scannerSave,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    onPressed: () => _saveToDocs(context, l),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Reset Button
          TextButton(
            onPressed: () => ref.read(scannerControllerProvider.notifier).reset(),
            child: Text(
              l.scannerReset,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
